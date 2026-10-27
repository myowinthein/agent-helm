# Shared fixture construction and assertions. Requiring this file calls no models.
require "digest"
require "open3"
require "pathname"

module HelmSmoke
  module_function

  def configuration_conflict(shared)
    alternate = shared.sub(/^ship-method: direct$/, "ship-method: pr")
    scenario = { files: { "AGENTS.md" => shared, "CLAUDE.md" => alternate }, pending: %w[direct pr] }
    validate_preconditions!("configuration-conflict", scenario)
    scenario
  end

  def normalize_gate(standard)
    { files: { "CLAUDE.md" => standard }, command: "normalize", unchanged: true,
      initial_message: "initialize fixture", expected_proposal: "chore(fixture): initialize",
      request: "Inspect normalization of the initial fixture commit. Use chore(fixture): initialize as its proposed correction. Show the pending final rewrite review; no history rewrite, record write or commit is approved." }
  end

  def connected_owner(original, rules: %w[git safety])
    raise "Fixture already contains a Rules section" if original.match?(/^## Rules$/)
    raise "Unexpected selected rules" unless !rules.empty? && rules.uniq == rules && (rules - %w[git safety writing]).empty?
    pointers = rules.map { |rule| ".claude/rules/#{rule}.md" }.join(" and ")
    original + "\n## Rules\n\nAt the start of every session, read and follow #{pointers}.\n"
  end

  def validate_preconditions!(name, scenario)
    if %w[configuration-conflict conflicting-config].include?(name)
      values = %w[AGENTS.md CLAUDE.md].map do |entry|
        matches = scenario.fetch(:files).fetch(entry).scan(/^ship-method: (direct|pr)$/).flatten
        raise "#{name}: fixture needs one current ship-method in each entry" unless matches.length == 1
        matches.first
      end
      raise "#{name}: fixture does not contain conflicting settings" unless values.sort == %w[direct pr]
    elsif name == "normalize-first-gate"
      message = scenario.fetch(:initial_message)
      proposal = scenario.fetch(:expected_proposal)
      raise "#{name}: fixture needs a non-Conventional initial subject" if message.empty? || message.include?(":") || message.include?("\n")
      raise "#{name}: fixture needs an explicit corrected proposal" unless proposal == "chore(fixture): initialize"
    end
  end

  def environment
    values = %w[GIT_DIR GIT_WORK_TREE GIT_COMMON_DIR GIT_INDEX_FILE GIT_OBJECT_DIRECTORY
                     GIT_ALTERNATE_OBJECT_DIRECTORIES GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT].to_h { |name| [name, nil] }
    values.merge("GIT_OPTIONAL_LOCKS" => "0", "GIT_NO_LAZY_FETCH" => "1",
                 "GIT_CONFIG_GLOBAL" => File::NULL, "GIT_CONFIG_NOSYSTEM" => "1", "GIT_TEMPLATE_DIR" => "")
  end

  def git(workspace, *arguments)
    output, status = Open3.capture2e(environment, "git", "-c", "core.fsmonitor=false", *arguments, chdir: workspace)
    raise "Fixture Git #{arguments.first} failed" unless status.success?
    output
  end

  def snapshot(workspace)
    root = Pathname(workspace)
    raise "Unexpected fixture root" if root.symlink? || !root.directory?
    result = {}
    visit = lambda do |directory|
      directory.children.sort.each do |path|
        relative = path.relative_path_from(root).to_s
        if path.symlink?
          result[relative] = "symlink:#{path.readlink}"
        elsif path.directory?
          result[relative] = :directory
          visit.call(path) unless relative == ".git"
        elsif path.file?
          result[relative] = Digest::SHA256.hexdigest(read_regular(root, relative))
        else
          result[relative] = "special:#{path.lstat.ftype}"
        end
      end
    end
    visit.call(root)
    result
  end

  def expected_snapshot(before, approved)
    result = before.dup
    approved.each do |name, contents|
      path = Pathname(name)
      raise "Approved fixture path must stay inside the consumer" if path.absolute? || path.each_filename.include?("..")
      result[name] = Digest::SHA256.hexdigest(contents)
      parent = path.parent
      until parent.to_s == "."
        if result.key?(parent.to_s) && result[parent.to_s] != :directory
          raise "Approved child would replace an existing parent: #{parent}"
        end
        result[parent.to_s] = :directory
        parent = parent.parent
      end
    end
    result
  end

  def assert_files_unchanged!(workspace, before, approved = {})
    expected = expected_snapshot(before, approved)
    actual = snapshot(workspace)
    changed = (actual.keys | expected.keys).select { |path| actual[path] != expected[path] }
    raise "Unexpected fixture file changes: #{changed.join(', ')}" unless changed.empty?
  end

  def read_regular(workspace, relative)
    root = Pathname(workspace)
    raise "Unexpected fixture root" if root.symlink? || !root.directory?
    parts = Pathname(relative).each_filename.to_a
    raise "Expected a contained regular fixture file" if Pathname(relative).absolute? || parts.empty? || parts.any? { |part| %w[. ..].include?(part) }
    path = root
    parents = []
    parts.each_with_index do |part, index|
      path = path.join(part)
      info = path.lstat
      raise "Fixture artifact must not traverse a symlink" if info.symlink?
      if index < parts.length - 1
        raise "Fixture artifact parent must be a directory" unless info.directory?
        parents << [path, [info.dev, info.ino]]
      else
        raise "Fixture artifact must be a regular file" unless info.file?
      end
    end
    before = path.lstat
    identity = ->(info) { [info.dev, info.ino, info.mode, info.size, info.mtime, info.ctime] }
    flags = File::RDONLY | File::BINARY | (File.const_defined?(:NOFOLLOW) ? File::NOFOLLOW : 0)
    File.open(path, flags) do |file|
      raise "Fixture artifact changed before read" unless identity.call(file.stat) == identity.call(before)
      contents = file.read.b
      raise "Fixture artifact changed during read" unless identity.call(file.stat) == identity.call(before) &&
        identity.call(path.lstat) == identity.call(before) &&
        parents.all? { |parent, stamp| info = parent.lstat; !info.symlink? && [info.dev, info.ino] == stamp }
      contents
    end
  rescue SystemCallError
    raise "Fixture artifact is missing or unsafe", cause: nil
  end

  def git_state(workspace)
    directory = Pathname(workspace).join(".git")
    return nil unless directory.exist? || directory.symlink?
    raise "Unexpected fixture Git directory" if directory.symlink? || !directory.directory?
    config = %w[config config.worktree].to_h do |name|
      path = directory.join(name)
      raise "Unexpected fixture Git config link" if path.symlink?
      [name, path.file? ? Digest::SHA256.hexdigest(read_regular(directory, name)) : nil]
    end
    { head: git(workspace, "rev-parse", "--verify", "HEAD"),
      checkout: git(workspace, "symbolic-ref", "--quiet", "HEAD"),
      refs: git(workspace, "for-each-ref", "--format=%(refname) %(objectname)"),
      index: git(workspace, "ls-files", "--stage", "-z"), config: config,
      index_flags: git(workspace, "ls-files", "-v", "-z"),
      operations: %w[MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD rebase-merge rebase-apply index.lock].select { |name| directory.join(name).exist? } }
  end

  def assert_git_unchanged!(workspace, before)
    after = git_state(workspace)
    raise "Unexpected fixture Git/index/ref/config changes" unless after == before
  end
end
