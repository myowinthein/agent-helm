# Offline assertions of the live-smoke harness; never invokes Claude or Codex.
require "fileutils"
require "tmpdir"
require_relative "smoke_support"

def assert(condition, message)
  raise message unless condition
end

def rejects
  begin
    yield
  rescue RuntimeError => error
    return error
  end
  raise "Expected the fixture assertion to reject this mutation"
end

def consumer
  Dir.mktmpdir("helm-smoke-support-") do |temporary|
    workspace = Pathname(temporary).join("consumer")
    workspace.mkpath
    yield workspace
  end
end

def repository(workspace, message = "chore(fixture): initialize")
  workspace.join("README.md").write("# Synthetic baseline\n")
  HelmSmoke.git(workspace, "init", "--quiet", "--initial-branch=main")
  HelmSmoke.git(workspace, "add", ".")
  HelmSmoke.git(workspace, "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid",
                "commit", "--quiet", "-m", message)
end

checks = {}
standard = "# Fixture\n\n## Project Config\n\nship-method: direct\ngit-auto-commit: false\n"

checks["current configuration conflict has different recognized values"] = lambda do
  [standard, "# Fixture\n\nProject configuration:\n\n```text\nship-method: direct\n```\n"].each do |input|
    scenario = HelmSmoke.configuration_conflict(input)
    HelmSmoke.validate_preconditions!("configuration-conflict", scenario)
    HelmSmoke.validate_preconditions!("conflicting-config", scenario)
    assert(scenario.fetch(:files).fetch("AGENTS.md") == input, "Changed the baseline entry")
    assert(scenario.fetch(:files).fetch("CLAUDE.md").include?("ship-method: pr\n"), "Missing conflicting active setting")
    assert(scenario.fetch(:pending) == %w[direct pr], "Pending evidence still uses retired values")
  end
  rejects { HelmSmoke.configuration_conflict("# Fixture\nship-method: solo\n") }
end

checks["vacuous configuration fixtures fail before any model call"] = lambda do
  scenario = HelmSmoke.configuration_conflict(standard)
  scenario[:files]["CLAUDE.md"] = standard
  rejects { HelmSmoke.validate_preconditions!("configuration-conflict", scenario) }
end

checks["normalize fixture commits an actual non-Conventional subject"] = lambda do
  scenario = HelmSmoke.normalize_gate(standard)
  HelmSmoke.validate_preconditions!("normalize-first-gate", scenario)
  consumer do |workspace|
    repository(workspace, scenario.fetch(:initial_message))
    subject = HelmSmoke.git(workspace, "log", "-1", "--format=%s").strip
    assert(subject == "initialize fixture" && !subject.include?(":"), "The gate fixture can no-op")
    assert(scenario.fetch(:expected_proposal) == "chore(fixture): initialize", "No exact correction expectation")
    assert(scenario.fetch(:request).include?("no history rewrite, record write or commit is approved"), "Fixture grants execution")
  end
  scenario[:initial_message] = scenario.fetch(:expected_proposal)
  rejects { HelmSmoke.validate_preconditions!("normalize-first-gate", scenario) }
end

checks["unchanged trees and exact approved nested files pass"] = lambda do
  consumer do |workspace|
    workspace.join("README.md").write("Human content\n")
    before = HelmSmoke.snapshot(workspace)
    HelmSmoke.assert_files_unchanged!(workspace, before)
    path = workspace.join(".claude/rules/git.md")
    path.parent.mkpath
    path.write("Approved rule\n")
    HelmSmoke.assert_files_unchanged!(workspace, before, ".claude/rules/git.md" => "Approved rule\n")
    workspace.join("README.md").write("Unapproved change\n")
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before, ".claude/rules/git.md" => "Approved rule\n") }
    rejects { HelmSmoke.expected_snapshot(before, "../outside.md" => "Bad path") }
  end
end

checks["modified and deleted files and extra empty directories are rejected"] = lambda do
  consumer do |workspace|
    path = workspace.join("README.md")
    path.write("Original\n")
    before = HelmSmoke.snapshot(workspace)
    path.write("Changed\n")
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before) }
    path.unlink
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before) }
    path.write("Original\n")
    workspace.join("unexpected").mkdir
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before) }
  end
end

checks["symlink directories are recorded without following their targets"] = lambda do
  consumer do |workspace|
    outside = workspace.parent.join("outside")
    outside.mkpath
    outside.join("not-a-consumer-file").write("First external contents")
    link = workspace.join("linked")
    link.make_symlink(outside)
    before = HelmSmoke.snapshot(workspace)
    assert(before["linked"] == "symlink:#{outside}", "Directory symlink is omitted")
    assert(!before.keys.any? { |path| path.start_with?("linked/") }, "Followed a directory symlink")
    outside.join("not-a-consumer-file").write("Different external contents")
    HelmSmoke.assert_files_unchanged!(workspace, before)
    link.delete
    link.make_symlink(workspace.parent.join("missing"))
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before) }
  end
end

checks["new regular and dangling symlinks are rejected"] = lambda do
  consumer do |workspace|
    before = HelmSmoke.snapshot(workspace)
    link = workspace.join("unexpected")
    link.make_symlink(workspace.parent.join("missing"))
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before) }
    link.delete
    target = workspace.parent.join("outside.txt")
    target.write("External file")
    link.make_symlink(target)
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before) }
  end
end

checks["approving a child cannot replace an existing link or file parent"] = lambda do
  %i[link file].each do |kind|
    consumer do |workspace|
      path = workspace.join("existing")
      if kind == :link
        outside = workspace.parent.join("outside")
        outside.mkdir
        path.make_symlink(outside)
      else
        path.write("Existing content")
      end
      before = HelmSmoke.snapshot(workspace)
      path.delete
      path.mkdir
      path.join("child.md").write("Approved child only")
      rejects { HelmSmoke.assert_files_unchanged!(workspace, before, "existing/child.md" => "Approved child only") }
    end
  end
end

checks["connection approval is fixed before output and rejects appended instructions"] = lambda do
  consumer do |workspace|
    workspace.join("AGENTS.md").write(standard)
    before = HelmSmoke.snapshot(workspace)
    approved = { "AGENTS.md" => HelmSmoke.connected_owner(standard) }
    workspace.join("AGENTS.md").write(approved.fetch("AGENTS.md"))
    HelmSmoke.assert_files_unchanged!(workspace, before, approved)
    workspace.join("AGENTS.md").open("a") { |file| file.write("\nUnapproved additional instruction.\n") }
    rejects { HelmSmoke.assert_files_unchanged!(workspace, before, approved) }
    rejects { HelmSmoke.connected_owner(approved.fetch("AGENTS.md")) }
  end
end

checks["artifact reads reject linked leaves and ancestors without revealing outside data"] = lambda do
  consumer do |workspace|
    outside = workspace.parent.join("outside")
    outside.mkdir
    outside.join("private.md").write("SYNTHETIC_OUTSIDE_CANARY")
    workspace.join("linked.md").make_symlink(outside.join("private.md"))
    workspace.join("linked-directory").make_symlink(outside)
    %w[linked.md linked-directory/private.md ../outside/private.md].each do |path|
      error = rejects { HelmSmoke.read_regular(workspace, path) }
      assert(!error.message.include?("SYNTHETIC_OUTSIDE_CANARY"), "Artifact contents entered a diagnostic")
    end
    workspace.join("regular.md").write("Approved readable content")
    assert(HelmSmoke.read_regular(workspace, "regular.md") == "Approved readable content", "Regular contained file rejected")
  end
end

checks["artifact reads and snapshots preserve Unicode and CRLF bytes"] = lambda do
  consumer do |workspace|
    contents = "Human ไทย →\r\n".b
    workspace.join("AGENTS.md").binwrite(contents)
    assert(HelmSmoke.read_regular(workspace, "AGENTS.md") == contents, "Artifact bytes were normalized")
    assert(HelmSmoke.snapshot(workspace).fetch("AGENTS.md") == Digest::SHA256.hexdigest(contents), "Snapshot changed encoded bytes")
  end
end

checks["unchanged Git state passes without optional index refresh"] = lambda do
  consumer do |workspace|
    repository(workspace)
    before = HelmSmoke.git_state(workspace)
    HelmSmoke.git(workspace, "status", "--short")
    HelmSmoke.assert_git_unchanged!(workspace, before)
  end
end

checks["staged-only content changes are rejected even with an unchanged worktree"] = lambda do
  consumer do |workspace|
    repository(workspace)
    files, state = HelmSmoke.snapshot(workspace), HelmSmoke.git_state(workspace)
    original = workspace.join("README.md").read
    workspace.join("README.md").write("Staged alternative\n")
    HelmSmoke.git(workspace, "add", "README.md")
    workspace.join("README.md").write(original)
    HelmSmoke.assert_files_unchanged!(workspace, files)
    rejects { HelmSmoke.assert_git_unchanged!(workspace, state) }
  end
end

checks["index flag-only mutations are rejected"] = lambda do
  %w[--assume-unchanged --skip-worktree].each do |flag|
    consumer do |workspace|
      repository(workspace)
      files, state = HelmSmoke.snapshot(workspace), HelmSmoke.git_state(workspace)
      HelmSmoke.git(workspace, "update-index", flag, "README.md")
      HelmSmoke.assert_files_unchanged!(workspace, files)
      assert(HelmSmoke.git_state(workspace).fetch(:index) == state.fetch(:index), "The flag fixture changed staged blobs")
      rejects { HelmSmoke.assert_git_unchanged!(workspace, state) }
    end
  end
end

checks["added branches and tags are rejected"] = lambda do
  consumer do |workspace|
    repository(workspace)
    before = HelmSmoke.git_state(workspace)
    HelmSmoke.git(workspace, "branch", "fixture-extra")
    rejects { HelmSmoke.assert_git_unchanged!(workspace, before) }
  end
  consumer do |workspace|
    repository(workspace)
    before = HelmSmoke.git_state(workspace)
    HelmSmoke.git(workspace, "tag", "fixture-tag")
    rejects { HelmSmoke.assert_git_unchanged!(workspace, before) }
  end
end

checks["changed HEAD or tag targets are rejected"] = lambda do
  consumer do |workspace|
    repository(workspace)
    HelmSmoke.git(workspace, "tag", "fixture-tag")
    original = HelmSmoke.git(workspace, "rev-parse", "HEAD").strip
    before = HelmSmoke.git_state(workspace)
    HelmSmoke.git(workspace, "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid",
                  "commit", "--allow-empty", "--quiet", "-m", "chore(fixture): extra commit")
    rejects { HelmSmoke.assert_git_unchanged!(workspace, before) }
    committed = HelmSmoke.git_state(workspace)
    HelmSmoke.git(workspace, "update-ref", "refs/tags/fixture-tag", "HEAD", original)
    rejects { HelmSmoke.assert_git_unchanged!(workspace, committed) }
  end
end

checks["local config changes fail without exposing their values"] = lambda do
  consumer do |workspace|
    repository(workspace)
    before = HelmSmoke.git_state(workspace)
    HelmSmoke.git(workspace, "config", "--local", "fixture.value", "SYNTHETIC_CANARY")
    error = rejects { HelmSmoke.assert_git_unchanged!(workspace, before) }
    assert(!error.message.include?("SYNTHETIC_CANARY"), "Config values entered the diagnostic")
  end
end

checks["new in-progress operation metadata fails"] = lambda do
  consumer do |workspace|
    repository(workspace)
    before = HelmSmoke.git_state(workspace)
    workspace.join(".git/CHERRY_PICK_HEAD").write(before.fetch(:head))
    rejects { HelmSmoke.assert_git_unchanged!(workspace, before) }
  end
end

checks["Git initialization and unsafe Git markers are rejected"] = lambda do
  consumer do |workspace|
    assert(HelmSmoke.git_state(workspace).nil?, "A fresh consumer has Git state")
    repository(workspace)
    rejects { HelmSmoke.assert_git_unchanged!(workspace, nil) }
  end
  consumer do |workspace|
    workspace.join(".git").make_symlink(workspace.parent.join("missing"))
    rejects { HelmSmoke.git_state(workspace) }
  end
  consumer do |workspace|
    repository(workspace)
    config = workspace.join(".git/config")
    contents = config.read
    config.delete
    outside = workspace.parent.join("outside-config")
    outside.write(contents)
    config.make_symlink(outside)
    rejects { HelmSmoke.git_state(workspace) }
  end
end

checks["inherited Git redirection cannot select another consumer"] = lambda do
  consumer do |workspace|
    repository(workspace)
    previous = ENV["GIT_DIR"]
    begin
      ENV["GIT_DIR"] = workspace.parent.join("not-this-repository").to_s
      actual = HelmSmoke.git(workspace, "rev-parse", "--show-toplevel").strip
      assert(Pathname(actual).realpath == workspace.realpath, "Inherited Git redirection escaped the fixture")
    ensure
      ENV["GIT_DIR"] = previous
    end
  end
end

checks.each do |name, test|
  test.call
  puts "PASS smoke support: #{name}"
end
puts "Passed #{checks.length} offline smoke-support scenarios; no models called."
