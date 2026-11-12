# Exercise acceptance oracles with real disposable graphs/remotes/recovery copies.
require "fileutils"
require "tmpdir"
require_relative "git_acceptance"
require_relative "test_support"

Dir.mktmpdir("helm-git-acceptance-") do |temporary|
  root = Pathname(temporary).realpath
  repo = root.join("consumer")
  repo.mkpath
  HelmSmoke.git(repo, "init", "--quiet", "--initial-branch=main")
  repo.join("source.txt").write("Synthetic fixture only\n")
  HelmSmoke.git(repo, "add", "source.txt")
  tree = HelmSmoke.git(repo, "write-tree").strip
  first = HelmGitAcceptance.commit_tree(repo, "initial fixture\n", [], tree)
  left = HelmGitAcceptance.commit_tree(repo, "fix(core): main change\n", [first], tree)
  right = HelmGitAcceptance.commit_tree(repo, "unique unaudited message\n", [first], tree)
  merge = HelmGitAcceptance.commit_tree(repo, "chore(core): merge\n", [left, right], tree)
  HelmSmoke.git(repo, "update-ref", "refs/heads/main", merge)
  HelmSmoke.git(repo, "update-ref", "refs/heads/feature", right)
  HelmSmoke.git(repo, "update-ref", "refs/tags/keep", first)
  HelmSmoke.git(repo, "update-ref", "refs/recovery/excluded", first)
  before = HelmGitAcceptance.graph(repo)
  bundle = root.join("original.bundle")
  HelmSmoke.git(repo, "bundle", "create", bundle.to_s, "--all")
  approved = { first => "chore(fixture): initialize\n" }
  new_first = HelmGitAcceptance.commit_tree(repo, approved.fetch(first), [], tree)
  new_left = HelmGitAcceptance.commit_tree(repo, "fix(core): main change\n", [new_first], tree)
  new_right = HelmGitAcceptance.commit_tree(repo, "unique unaudited message\n", [new_first], tree)
  new_merge = HelmGitAcceptance.commit_tree(repo, "chore(core): merge\n", [new_left, new_right], tree)
  mapping = { first => new_first, left => new_left, right => new_right, merge => new_merge }
  HelmSmoke.git(repo, "update-ref", "refs/heads/main", new_merge)
  HelmSmoke.git(repo, "update-ref", "refs/heads/feature", new_right)
  after = HelmGitAcceptance.graph(repo)
  raise "Wrong derived fixture correspondence" unless HelmGitAcceptance.derive_mapping(before, after, approved) == mapping
  HelmGitAcceptance.assert_rewrite!(before, after, mapping, approved)
  rejects { HelmGitAcceptance.assert_rewrite!(before, after, mapping.reject { |id, _| id == right }, approved) }
  rejects { HelmGitAcceptance.assert_rewrite!(before, after, mapping, {}) }
  changed = Marshal.load(Marshal.dump(after))
  changed[:commits][new_right][:message] = "silently changed unique message\n"
  rejects { HelmGitAcceptance.assert_rewrite!(before, changed, mapping, approved) }
  changed = Marshal.load(Marshal.dump(after))
  changed[:commits][new_left][:headers].map! { |line| line.start_with?("author ") ? "author Wrong <wrong@example.invalid> 0 +0000" : line }
  rejects { HelmGitAcceptance.assert_rewrite!(before, changed, mapping, approved) }
  changed = Marshal.load(Marshal.dump(after))
  changed[:refs]["refs/tags/keep"] = new_first
  rejects { HelmGitAcceptance.assert_rewrite!(before, changed, mapping, approved) }
  changed[:refs]["refs/heads/feature"] = right
  rejects { HelmGitAcceptance.assert_rewrite!(before, changed, mapping, approved) }
  recovery = root.join("independent recovery")
  recovery.mkpath
  HelmGitAcceptance.verify_bundle!(repo, bundle, [merge, right], recovery)
  missing_ref_recovery = root.join("missing-ref recovery")
  missing_ref_recovery.mkpath
  rejects { HelmGitAcceptance.verify_bundle!(repo, bundle, [merge], missing_ref_recovery, expected_refs: { "refs/tags/absent" => first }) }
  thin = root.join("thin.bundle")
  HelmSmoke.git(repo, "bundle", "create", thin.to_s, "#{new_first}..main")
  HelmSmoke.git(repo, "bundle", "verify", thin.to_s) # Source objects can satisfy a thin bundle.
  empty_recovery = root.join("thin recovery")
  empty_recovery.mkpath
  rejects { HelmGitAcceptance.verify_bundle!(repo, thin, [new_merge], empty_recovery) }
  puts "PASS Git oracle: merge/shared-ID rewrite, unique messages, metadata, tags/excluded refs and independent recovery"

  remote = root.join("private fixture.git")
  HelmSmoke.git(repo, "init", "--quiet", "--bare", remote.to_s)
  HelmSmoke.git(repo, "push", "--quiet", "--no-follow-tags", remote.to_s, "#{first}:refs/heads/main", "#{first}:refs/heads/feature")
  frozen = HelmGitAcceptance.remote_refs(repo, remote)
  HelmSmoke.git(repo, "push", "--quiet", "--no-follow-tags", remote.to_s, "#{left}:refs/heads/main")
  moved = HelmGitAcceptance.remote_refs(repo, remote)
  # The oracle must reject an unexpected advance before classifying any publication.
  rejects { HelmGitAcceptance.assert_publication!(moved, frozen) }
  output, status = Open3.capture2e(HelmSmoke.environment, "git", "push", "--quiet", "--no-follow-tags",
    "--force-with-lease=refs/heads/main:#{first}", remote.to_s, "#{new_merge}:refs/heads/main", chdir: repo)
  raise "Stale fixture lease unexpectedly succeeded" if status.success?
  HelmGitAcceptance.assert_publication!(HelmGitAcceptance.remote_refs(repo, remote), moved)
  # Simulate one observed success followed by an interrupted second action.
  HelmSmoke.git(repo, "push", "--quiet", "--no-follow-tags", "--force-with-lease=refs/heads/main:#{left}", remote.to_s, "#{new_merge}:refs/heads/main")
  partial = HelmGitAcceptance.remote_refs(repo, remote)
  HelmGitAcceptance.assert_publication!(partial, { "refs/heads/main" => new_merge, "refs/heads/feature" => first })
  HelmSmoke.git(repo, "push", "--quiet", "--no-follow-tags", remote.to_s, "#{right}:refs/heads/feature")
  HelmGitAcceptance.assert_publication!(HelmGitAcceptance.remote_refs(repo, remote), { "refs/heads/main" => new_merge, "refs/heads/feature" => right })
  puts "PASS publication oracle: moved remote, fixed stale lease, partial success and missing-action completion"

  replacement_remote = root.join("manual-history.git")
  HelmSmoke.git(repo, "init", "--quiet", "--bare", replacement_remote.to_s)
  HelmSmoke.git(repo, "push", "--quiet", "--no-follow-tags", replacement_remote.to_s,
    "#{left}:refs/heads/main", "#{first}:refs/tags/keep")
  replacement_before = HelmGitAcceptance.remote_refs(repo, replacement_remote)
  consumer_before = HelmGitAcceptance.graph(repo)
  isolated = root.join("replacement-backup.git")
  HelmSmoke.git(repo, "init", "--quiet", "--bare", isolated.to_s)
  HelmSmoke.git(isolated, "fetch", "--quiet", "--no-tags", "--no-write-fetch-head",
    "--no-recurse-submodules", "--no-auto-maintenance", replacement_remote.to_s,
    "refs/heads/main:refs/heads/remote-main")
  raise "Backup fetched the wrong remote tip" unless HelmSmoke.git(isolated, "rev-parse", "refs/heads/remote-main").strip == left
  replacement_bundle = root.join("remote-before.bundle")
  HelmSmoke.git(isolated, "bundle", "create", replacement_bundle.to_s, "refs/heads/remote-main")
  bundle_bytes = replacement_bundle.binread
  replacement_recovery = root.join("replacement recovery")
  replacement_recovery.mkpath
  HelmGitAcceptance.verify_bundle!(isolated, replacement_bundle, [left], replacement_recovery,
    expected_refs: { "refs/heads/remote-main" => left })
  raise "Remote backup changed consumer refs or commits" unless HelmGitAcceptance.graph(repo) == consumer_before
  raise "Isolated fetch wrote consumer FETCH_HEAD" if repo.join(".git/FETCH_HEAD").exist?
  HelmSmoke.git(repo, "push", "--quiet", "--no-follow-tags",
    "--force-with-lease=refs/heads/main:#{left}", replacement_remote.to_s, "#{new_merge}:refs/heads/main")
  HelmGitAcceptance.assert_publication!(HelmGitAcceptance.remote_refs(repo, replacement_remote),
    { "refs/heads/main" => new_merge })
  raise "Replacement changed the preserved tag" unless HelmSmoke.git(repo, "ls-remote", replacement_remote.to_s, "refs/tags/keep").split.first == first
  raise "Publication changed the original remote backup" unless replacement_bundle.binread == bundle_bytes
  raise "Original remote snapshot was lost" unless HelmSmoke.git(replacement_recovery, "cat-file", "-e", "#{replacement_before.fetch("refs/heads/main")}^{commit}").empty?
  raise "Replacement invented normalize state" if isolated.join("agent-helm/normalize-handoffs").exist?
  puts "PASS replacement backup: isolated fetch, independent old-history recovery, unchanged consumer, fixed-lease push and preserved tag/bundle"

  report = repo.join(".helm/archive/step1-explore.md")
  report.parent.mkpath
  report.write("Approved fictional report\n")
  protected = { "source.txt" => repo.join("source.txt").read }
  reports = { ".helm/archive/step1-explore.md" => Digest::SHA256.hexdigest(report.read) }
  HelmGitAcceptance.assert_archive_inputs!(repo, reports, protected)
  report.write("Tampered report\n")
  rejects { HelmGitAcceptance.assert_archive_inputs!(repo, reports, protected) }
  report.write("Approved fictional report\n")
  repo.join("source.txt").write("Overwritten protected input\n")
  rejects { HelmGitAcceptance.assert_archive_inputs!(repo, reports, protected) }
  puts "PASS archive oracle: tampered report and changed protected inputs rejected"
end
puts "These are fixture/oracle checks, not evidence that a model followed normalize, ship or archive."
