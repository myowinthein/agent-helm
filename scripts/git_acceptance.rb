# Oracles for disposable Git/recovery fixtures, never workflow implementation.
require "json"
require_relative "smoke_support"

module HelmGitAcceptance
  module_function

  def commit_tree(repo, message, parents, tree)
    environment = HelmSmoke.environment.merge("GIT_AUTHOR_NAME" => "Helm fixture", "GIT_AUTHOR_EMAIL" => "fixture@example.invalid",
      "GIT_COMMITTER_NAME" => "Helm fixture", "GIT_COMMITTER_EMAIL" => "fixture@example.invalid",
      "GIT_AUTHOR_DATE" => "2026-01-01T00:00:00Z", "GIT_COMMITTER_DATE" => "2026-01-01T00:00:00Z")
    output, status = Open3.capture2e(environment, "git", "commit-tree", tree,
      *parents.flat_map { |oid| ["-p", oid] }, chdir: repo, stdin_data: message)
    raise "Synthetic commit construction failed" unless status.success?
    output.strip
  end

  def graph(workspace)
    refs = HelmSmoke.git(workspace, "for-each-ref", "--format=%(refname) %(objectname)").lines.to_h { |line| line.strip.split(" ", 2) }
    commits = HelmSmoke.git(workspace, "rev-list", "--all").lines.map(&:strip).to_h do |oid|
      raw = HelmSmoke.git(workspace, "cat-file", "commit", oid)
      headers, message = raw.split("\n\n", 2)
      [oid, { headers: headers.lines.map(&:chomp), message: message }]
    end
    { refs: refs, commits: commits, config: HelmSmoke.git_state(workspace).fetch(:config),
      checkout: HelmSmoke.git(workspace, "symbolic-ref", "HEAD"),
      index: HelmSmoke.git(workspace, "ls-files", "--stage", "-z") }
  end

  def assert_rewrite!(before, after, mapping, approved_messages)
    raise "Incomplete fixture rewrite map" unless mapping.keys.sort == before.fetch(:commits).keys.sort && mapping.values.uniq.length == mapping.length
    raise "Changed fixture remote/config/index/checkout" unless %i[config checkout index].all? { |key| before[key] == after[key] }
    expected_refs = before.fetch(:refs).to_h { |ref, oid| [ref, ref.start_with?("refs/heads/") ? mapping.fetch(oid) : oid] }
    raise "Changed or missing fixture ref" unless after.fetch(:refs) == expected_refs
    before.fetch(:commits).each do |oid, record|
      actual = after.fetch(:commits).fetch(mapping.fetch(oid)) { raise "Missing mapped fixture commit" }
      headers = record.fetch(:headers).map do |header|
        header.start_with?("parent ") ? "parent #{mapping.fetch(header.delete_prefix('parent '))}" : header
      end
      unless actual.fetch(:headers) == headers && actual.fetch(:message) == approved_messages.fetch(oid, record.fetch(:message))
        raise "Fixture rewrite changed an unapproved message, tree, graph or metadata"
      end
    end
  end

  def derive_mapping(before, after, approved_messages)
    pending = before.fetch(:commits).dup
    mapping = {}
    until pending.empty?
      progressed = false
      pending.keys.each do |oid|
        record = pending.fetch(oid)
        parents = record.fetch(:headers).grep(/^parent /).map { |h| h.delete_prefix("parent ") }
        next unless parents.all? { |id| mapping.key?(id) }
        expected = record.fetch(:headers).map { |h| h.start_with?("parent ") ? "parent #{mapping.fetch(h.delete_prefix('parent '))}" : h }
        candidates = after.fetch(:commits).select do |_, candidate|
          candidate.fetch(:headers) == expected && candidate.fetch(:message) == approved_messages.fetch(oid, record.fetch(:message))
        end.keys
        raise "Missing or ambiguous current-run correspondence" unless candidates.length == 1
        mapping[oid] = candidates.first
        pending.delete(oid)
        progressed = true
      end
      raise "Incomplete fixture parent graph" unless progressed
    end
    mapping
  end

  def verify_bundle!(workspace, bundle, expected_tips, recovery, expected_refs: {})
    HelmSmoke.git(workspace, "bundle", "verify", bundle.to_s)
    heads = HelmSmoke.git(workspace, "bundle", "list-heads", bundle.to_s).lines.to_h { |line| oid, ref = line.strip.split(" ", 2); [ref, oid] }
    raise "Recovery bundle omitted a required branch/tag identity" unless expected_refs.all? { |ref, oid| heads[ref] == oid }
    HelmSmoke.git(recovery, "init", "--quiet", "--initial-branch=main")
    HelmSmoke.git(recovery, "bundle", "verify", bundle.to_s)
    HelmSmoke.git(recovery, "bundle", "unbundle", bundle.to_s)
    expected_tips.each do |oid|
      HelmSmoke.git(recovery, "cat-file", "-e", "#{oid}^{commit}")
      HelmSmoke.git(recovery, "rev-list", "--objects", "--missing=error", oid)
    end
    raise "Recovery borrowed alternate objects" if recovery.join(".git/objects/info/alternates").exist?
  end

  def remote_refs(repository, destination)
    HelmSmoke.git(repository, "ls-remote", "--heads", destination.to_s).lines.to_h do |line|
      oid, ref = line.strip.split("\t", 2)
      [ref, oid]
    end
  end

  def assert_publication!(observed, expected)
    raise "Unexpected local fixture publication result" unless observed == expected
  end

  def assert_archive_inputs!(workspace, reports, protected_before)
    reports.each do |relative, checksum|
      actual = Digest::SHA256.hexdigest(HelmSmoke.read_regular(workspace, relative))
      raise "Tampered fixture report/output" unless actual == checksum
    end
    protected_before.each do |relative, bytes|
      raise "Protected fixture input changed" unless HelmSmoke.read_regular(workspace, relative) == bytes.b
    end
  end
end
