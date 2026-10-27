# Direct guards for the live runner's extracted checks, without any model calls.
require "fileutils"
require "tmpdir"
require_relative "acceptance_cases"

def expect(condition)
  raise "Acceptance oracle assertion failed" unless condition
end

def rejects_with(message)
  failure = nil
  begin
    yield
  rescue RuntimeError => error
    failure = error.message
  end
  expect(failure == message)
end

def commit_fixture(workspace, message)
  environment = HelmSmoke.environment.merge("GIT_AUTHOR_DATE" => "2026-01-01T00:00:00Z",
    "GIT_COMMITTER_DATE" => "2026-01-01T00:00:00Z")
  _, status = Open3.capture2e(environment, "git", "-c", "core.fsmonitor=false",
    "commit", "--quiet", "-m", message, chdir: workspace)
  raise "Synthetic fixture commit failed" unless status.success?
  HelmSmoke.git(workspace, "rev-parse", "HEAD").strip
end

def with_consumer
  Dir.mktmpdir("helm-direct-oracles-") do |temporary|
    container = Pathname(temporary).realpath
    workspace = container.join("consumer")
    workspace.mkpath
    HelmSmoke.git(workspace, "init", "--quiet", "--initial-branch=main")
    HelmSmoke.git(workspace, "config", "user.name", "Helm fixture")
    HelmSmoke.git(workspace, "config", "user.email", "fixture@example.invalid")
    workspace.join("app.py").write("def greeting(language=None):\n    return 'Fictional fixture'\n")
    HelmSmoke.git(workspace, "add", "app.py")
    commit_fixture(workspace, "chore(fixture): initialize")
    yield workspace, container
  end
end

with_consumer do |workspace, container|
  first = HelmSmoke.git(workspace, "rev-parse", "HEAD").strip
  tree = HelmSmoke.git(workspace, "rev-parse", "HEAD^{tree}").strip
  tip = HelmGitAcceptance.commit_tree(workspace, "fix(fixture): descendant\n", [first], tree)
  HelmSmoke.git(workspace, "update-ref", "refs/heads/main", tip)
  HelmSmoke.git(workspace, "branch", "feature", first)
  HelmSmoke.git(workspace, "tag", "-a", "keep", first, "-m", "Preserved fixture tag")
  graph_before = HelmGitAcceptance.graph(workspace)
  before = HelmSmoke.snapshot(workspace)
  proof = container.join("private proof")
  proof.mkpath
  proof.chmod(0700)
  HelmSmoke.git(workspace, "bundle", "create", proof.join("recovery.bundle").to_s, "--all")
  replacement = "chore(fixture): bootstrap\n"
  new_first = HelmGitAcceptance.commit_tree(workspace, replacement, [], tree)
  new_tip = HelmGitAcceptance.commit_tree(workspace, "fix(fixture): descendant\n", [new_first], tree)
  mapping = { first => new_first, tip => new_tip }
  HelmSmoke.git(workspace, "update-ref", "refs/heads/main", new_tip)
  HelmSmoke.git(workspace, "update-ref", "refs/heads/feature", new_first)
  proof.join("verified-map.json").write(JSON.generate(mapping))
  record = workspace.join(".helm/normalize-log.json")
  record.parent.mkpath
  checkpoint = { "schema_version" => 2, "branches" => { "main" => {
    "last_checked_commit" => new_first, "last_checked_date" => "2026-01-01",
    "review_kind" => "semantic", "review_contract" => 1, "policy_fingerprint" => "0" * 64 } } }
  record.write(JSON.generate(checkpoint))
  HelmSmoke.git(workspace, "add", ".helm/normalize-log.json")
  commit_fixture(workspace, "chore(fixture): record reviewed prefix")
  scenario = { graph_before: graph_before, replacements: { first => replacement }, private_path: proof }
  approved = {}
  verify = -> { HelmAcceptance.verify_normalize!(workspace: workspace, container: container,
    scenario: scenario, before: before, approved: approved) }
  verify.call
  expect(approved == { ".helm/normalize-log.json" => record.binread })
  expect(HelmSmoke.git(container.join("independent recovery"), "cat-file", "-t", tip).strip == "commit")
  original = record.binread
  checkpoint["branches"]["main"]["last_checked_commit"] = new_tip
  record.write(JSON.generate(checkpoint))
  rejects_with("Normalize checkpoint overstates the reviewed prefix", &verify)
  record.binwrite(original)
  proof.chmod(0755)
  rejects_with("Private proof is not owner-only", &verify)
  proof.chmod(0700)
end
puts "PASS direct normalize oracle: reviewed prefix, approved bytes, independent recovery and private proof"

[false, true].each do |successful|
  with_consumer do |workspace, container|
    setup = HelmAcceptanceCases.prepare_test(workspace, container, deferred: !successful, successful: successful)
    scenario = { test_fixture: setup.fetch(:test_fixture) }
    before = HelmSmoke.snapshot(workspace)
    before_git = HelmSmoke.git_state(workspace)
    approved = setup.fetch(:approved).dup
    workspace.join("tests/test_greeting.py").write(approved.fetch("tests/test_greeting.py"))
    record = workspace.join(".helm/test-log.json")
    if successful
      HelmSmoke.git(workspace, "add", "tests/test_greeting.py")
      code = commit_fixture(workspace, "test(fixture): add language case")
      document = JSON.parse(record.read)
      document.fetch("cases").first.merge!("state" => "resolved", "closure" => {
        "reason" => "tested", "refs" => ["tests/test_greeting.py"], "method" => "runtime",
        "outcome" => "Synthetic oracle input; this is not a workflow test-pass claim.",
        "commit" => code, "command" => "synthetic oracle fixture", "scope" => "Disposable metadata only" })
      record.write(JSON.generate(document))
      HelmSmoke.git(workspace, "add", ".helm/test-log.json")
      closure = commit_fixture(workspace, "test(fixture): record synthetic closure")
    end
    result = { calls: [], tool_outputs: [] }
    verify = -> { HelmAcceptance.verify_test_lifecycle!(workspace: workspace,
      package: Pathname(__dir__).parent, scenario: scenario, before: before,
      before_git: before_git, approved: approved, result: result) }
    verify.call
    expect(approved.fetch(".helm/test-log.json") == record.binread)
    if successful
      document.fetch("cases").first.fetch("closure")["commit"] = closure
      record.write(JSON.generate(document))
      rejects_with("Successful closure lacks actual separate code provenance", &verify)
    else
      result[:calls] = [{ "input" => { "command" => "python3 -B -m unittest discover -s tests" } }]
      rejects_with("Deferred tests were executed", &verify)
      result[:calls] = []
      scenario.fetch(:test_fixture)[:deferred] = false
      rejects_with("Expected failed verification never ran", &verify)
      # This supplied trace is a unit-test input, not an executed model workflow.
      result[:tool_outputs] = ["FAILED (errors=1)\nTypeError: synthetic fixture"]
      verify.call
    end
  end
end
puts "PASS direct test oracle: open drafts, failure evidence, and distinct code-before-closure commits"

with_consumer do |workspace, container|
  old_tip = HelmSmoke.git(workspace, "rev-parse", "HEAD").strip
  tree = HelmSmoke.git(workspace, "rev-parse", "HEAD^{tree}").strip
  new_tip = HelmGitAcceptance.commit_tree(workspace, "fix(fixture): published\n", [old_tip], tree)
  remote = container.join("private fixture.git")
  HelmSmoke.git(workspace, "init", "--quiet", "--bare", remote.to_s)
  HelmSmoke.git(workspace, "push", "--quiet", "--no-follow-tags", remote.to_s,
    "#{new_tip}:refs/heads/main", "#{old_tip}:refs/heads/feature")
  proof = container.join("private proof")
  proof.mkpath
  original = { "remote_expectations" => { "refs/heads/main" => old_tip } }
  proof.join("handoff.json").write(JSON.generate(original))
  scenario = { local_remote: remote, private_path: proof, immutable_proof: original,
    expected_remote: { "refs/heads/main" => new_tip, "refs/heads/feature" => old_tip } }
  call = { "input" => { "command" => "git ls-remote #{remote}" }, "output" => "#{new_tip}\trefs/heads/main" }
  result = { calls: [call] }
  name = "history-remote-moved"
  verify = -> { HelmAcceptance.verify_publication!(name: name, workspace: workspace, scenario: scenario, result: result) }
  verify.call
  call["output"] = "#{old_tip}\trefs/heads/main"
  rejects_with("Actual remote main was not inspected", &verify)
  call["output"] = "#{new_tip}\trefs/heads/main"
  proof.join("handoff.json").write(JSON.generate("remote_expectations" => { "refs/heads/main" => new_tip }))
  rejects_with("Original proof or fixed expectations were replaced", &verify)
  proof.join("handoff.json").write(JSON.generate(original))
  result[:calls] << { "input" => { "command" => "git push fixture" } }
  rejects_with("Moved remote caused a publication attempt", &verify)
  result[:calls].pop
  scenario[:expected_remote]["refs/heads/main"] = old_tip
  rejects_with("Unexpected local fixture publication result", &verify)
  scenario[:expected_remote]["refs/heads/main"] = new_tip
  HelmSmoke.git(workspace, "push", "--quiet", "--no-follow-tags",
    "--force-with-lease=refs/heads/feature:#{old_tip}", remote.to_s, "#{new_tip}:refs/heads/feature")
  scenario[:expected_remote]["refs/heads/feature"] = new_tip
  name = "history-partial-resume"
  rejects_with("Partial resume omitted its fixed feature lease", &verify)
  result[:calls] << { "input" => { "command" => "git push --force-with-lease=refs/heads/feature:#{old_tip} fixture" } }
  verify.call
end
puts "PASS direct publication oracle: real remote refs, paired evidence, immutable proof and missing-action lease"
puts "Passed 3 direct acceptance-oracle groups; synthetic inputs only, no models or workflow executions."
