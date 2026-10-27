# Optional live checks: real CLI behavior in disposable projects, never a global install.
require "digest"
require "fileutils"
require "json"
require "open3"
require "pathname"
require "tempfile"
require "timeout"
require "tmpdir"
require_relative "smoke_support"

client = ARGV.fetch(0, "codex")
abort "Usage: ruby scripts/smoke_layout.rb [codex|claude] [case ...]" unless %w[codex claude].include?(client)
$stdout.sync = true
root = Pathname(__dir__).parent.realpath
shared = "# Fictional project\n\nProject configuration:\n\n```text\nship-method: direct\ngit-auto-commit: false\nreadme-style: custom\n```\n\n## Team agreements\n\nPreserve the backup before replacing the catalog.\n\n<!-- last-reviewed: {review_hash} -->\n"
claude_only = "\n## Claude-specific\n\nUse Claude plan mode for catalog changes.\n"
adapter = "@AGENTS.md\n"
reverse = "# Codex entry\n\nProject instructions and Helm configuration live in CLAUDE.md. Read and follow that file before any project work; do not duplicate or migrate its configuration here.\n\n## Extra agreement\n\nKeep the daily retention preference.\n"
merged = shared.sub("\n<!-- last-reviewed:", "\n## Extra agreement\n\nKeep the daily retention preference.\n\n<!-- last-reviewed:")
reference_rules = "\n## Rules\n\nAt the start of every session, read and follow .claude/rules/git.md and .claude/rules/safety.md.\n"
cases = {
  "agents-only-current" => { files: { "AGENTS.md" => shared }, expected: { "AGENTS.md" => shared, "CLAUDE.md" => adapter } },
  "claude-only-migration" => { files: { "CLAUDE.md" => shared + claude_only }, expected: { "AGENTS.md" => shared, "CLAUDE.md" => adapter + claude_only } },
  "reverse-bridge-migration" => { files: { "CLAUDE.md" => shared + claude_only, "AGENTS.md" => reverse }, expected: { "AGENTS.md" => merged, "CLAUDE.md" => adapter + claude_only } },
  "independent-merge" => { files: { "AGENTS.md" => shared, "CLAUDE.md" => "## Extra agreement\n\nKeep the daily retention preference.\n" + claude_only }, expected: { "AGENTS.md" => merged, "CLAUDE.md" => adapter + claude_only } },
  "mutual-cycle-migration" => { files: { "CLAUDE.md" => "@AGENTS.md\n\n" + shared + claude_only, "AGENTS.md" => reverse }, expected: { "AGENTS.md" => merged, "CLAUDE.md" => adapter + claude_only } },
  "partial-adapter-migration" => { files: { "AGENTS.md" => shared, "CLAUDE.md" => adapter + reference_rules + claude_only }, expected: { "AGENTS.md" => shared + reference_rules, "CLAUDE.md" => adapter + claude_only } },
  "partial-adapter-adopt-stop" => { command: "adopt", files: { "AGENTS.md" => shared, "CLAUDE.md" => adapter + reference_rules + claude_only }, pending: %w[log], request: "Run adopt. The adapter still owns shared Rules; I have not approved migration." },
  "independent-awaiting-approval" => { files: { "AGENTS.md" => shared, "CLAUDE.md" => "## Extra agreement\n\nKeep the daily retention preference.\n" + claude_only }, pending: %w[AGENTS.md CLAUDE.md retention], request: "Run log. No migration or reconciliation diff has been approved; show the comparison and pending choices, then stop." },
  "configuration-conflict" => HelmSmoke.configuration_conflict(shared).merge(request: "Run log. I have not chosen which conflicting configuration to keep."),
  "shadowed-entry" => { files: { "AGENTS.md" => shared, "CLAUDE.md" => adapter, "AGENTS.override.md" => "# Local override\n\nDo not connect this override to the persistent project entry.\n" }, pending: %w[AGENTS.override.md], request: "Run log and establish shared project instructions." },
  "cancel-migration" => { files: { "CLAUDE.md" => shared }, request: "Run log. At the layout migration choice, choose Cancel. Do not run a knowledge scan." },
  "fresh-no-git" => { files: {}, no_git: true, fresh: true, request: "Run log. I approve the full scan and creating both root entries. Choose direct shipping and no automatic commits. No special safety risks apply to this fictional Markdown-only project. Do not initialize Git, invent a review hash, or create rules." },
  "fresh-skip" => { files: {}, no_git: true, request: "Run log, choosing Skip at the full-scan assessment. Do not create any entry files." },
  "canonical-adopt-copy" => { command: "adopt", copy: true, files: { "AGENTS.md" => shared, "CLAUDE.md" => adapter + claude_only }, expected: { "CLAUDE.md" => adapter + claude_only }, request: "Run adopt for Git and safety only. I approve installing those two Helm copies and adding their explicit Rules pointers to the existing AGENTS.md owner. Keep all existing instructions, configuration and the review marker unchanged; preserve CLAUDE.md byte-for-byte." },
  # Current managed markers remain byte-for-byte intact on connection.
  "canonical-adopt-connect" => { command: "adopt", files: { "AGENTS.md" => shared + reference_rules,
    ".claude/rules/git.md" => "<!-- helm-rule: agent-helm@v9.9.9 -->\n" + root.join("rules/git.md").read,
    ".claude/rules/safety.md" => "<!-- helm-rule: agent-helm@v9.9.9 -->\n" + root.join("rules/safety.md").read },
    expected: { "AGENTS.md" => shared + reference_rules, "CLAUDE.md" => adapter },
    request: "Run adopt. Keep the newer project rules. I approve creating CLAUDE.md with exactly @AGENTS.md followed by a newline. Preserve AGENTS.md and both rules byte-for-byte." }
}
cases.delete("canonical-adopt-copy") if client == "claude"
selected = ARGV.drop(1)
unknown = selected - cases.keys
abort "Unknown cases: #{unknown.join(", ")}" unless unknown.empty?
cases.select! { |name, _| selected.include?(name) } unless selected.empty?

def git(workspace, *args)
  HelmSmoke.git(workspace, *args).strip
end

cases.each do |name, scenario|
  HelmSmoke.validate_preconditions!(name, scenario)
  Dir.mktmpdir("helm-layout-#{client}-#{name}-") do |temp|
    workspace = Pathname(temp).join("consumer project")
    workspace.mkpath
    files = scenario.fetch(:files).merge("README.md" => "# Fictional catalog\n\nA Markdown-only catalog maintained by a solo developer. No deployment or database.\n")
    files.each { |path, contents| file = workspace.join(path); file.parent.mkpath; file.write(contents) }
    unless scenario[:no_git]
      git(workspace, "init", "--quiet", "--initial-branch=main")
      git(workspace, "add", ".")
      git(workspace, "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid", "commit", "--quiet", "-m", "chore(fixture): initialize")
      review_hash = git(workspace, "rev-parse", "HEAD")
      files.each do |path, contents|
        next unless contents.include?("{review_hash}")
        workspace.join(path).write(contents.gsub("{review_hash}", review_hash))
      end
      git(workspace, "add", ".")
      git(workspace, "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid", "commit", "--quiet", "--allow-empty", "-m", "docs(fixture): record review marker only")
      before_head = git(workspace, "rev-parse", "HEAD")
    end
    before = HelmSmoke.snapshot(workspace)
    before_git = HelmSmoke.git_state(workspace)
    expected = scenario.fetch(:expected, {}).transform_values { |contents| contents.gsub("{review_hash}", review_hash.to_s) }
    if scenario[:copy]
      expected["AGENTS.md"] = HelmSmoke.connected_owner(files.fetch("AGENTS.md").gsub("{review_hash}", review_hash.to_s))
      version = JSON.parse(root.join(".claude-plugin/plugin.json").read).fetch("version")
      %w[git.md safety.md].each do |rule|
        expected[".claude/rules/#{rule}"] = "<!-- helm-rule: agent-helm@v#{version} -->\n" + root.join("rules", rule).read
      end
    end
    approved = expected.map { |path, contents| "#{path}:\n```markdown\n#{contents}```" }.join("\n\n")
    request = scenario[:request] || "Run log. I approve exactly the following final file contents for the layout migration/adapter creation. Preserve all other files. Skip any subsequent knowledge scan, investigation or gap update.\n\n#{approved}"
    request += "\n\nI approve exactly these file contents; preserve all other files:\n\n#{approved}" if scenario[:copy]
    operation = scenario.fetch(:command, "log")
    instructions = "This is a disposable fictional fixture at #{workspace}. Operate only in it and read the selected packaged workflow/resources. Do not access real projects, network, external services or global settings. Do not commit, push or initialize Git; stop finalization with files uncommitted as explicitly requested by this fixture's user. Follow actual workflow questions; present unanswered choices and stop instead of inventing approval. Explicit approvals of exact final contents in the request authorize only that transformation."
    prompt = "#{instructions}\n\nRead #{root.join('skills', operation, 'SKILL.md')} and execute that Helm workflow with this request:\n\n#{request}"
    args = if client == "claude"
      ["claude", "--setting-sources", "", "--strict-mcp-config", "--model", "claude-opus-5-5", "--effort", "high",
       "--tools", "Read,Glob,Grep,Bash,Write,Edit", "--allowedTools", "Read,Glob,Grep,Bash,Write,Edit",
       "--no-session-persistence", "--output-format", "json", "-p", prompt]
    else
      ["codex", "exec", "--ephemeral", "--skip-git-repo-check", "--sandbox", "workspace-write", "--json", "--cd", workspace.to_s, prompt]
    end
    Tempfile.create("helm-layout-output") do |stdout|
      Tempfile.create("helm-layout-errors") do |stderr|
        pid = Process.spawn(HelmSmoke.environment, *args, chdir: workspace, in: File::NULL, out: stdout, err: stderr, pgroup: true)
        begin
          _, status = Timeout.timeout(300) { Process.wait2(pid) }
        rescue Timeout::Error
          Process.kill("KILL", -pid) rescue nil
          Process.wait(pid) rescue nil
          raise "#{name}: #{client} timed out"
        end
        stdout.rewind; raw = stdout.read
        stderr.rewind
        raise "#{name}: CLI failed: #{stderr.read[-1000..]} #{raw[-2000..]}" unless status.success?
        if client == "claude"
          result = JSON.parse(raw)
          raise "#{name}: wrong model or error" unless result.fetch("modelUsage").key?("claude-opus-5-5") && !result["is_error"]
          answer = result.fetch("result")
        else
          events = raw.lines.filter_map { |line| JSON.parse(line) rescue nil }
          raise "#{name}: Codex failed" if events.any? { |e| %w[error turn.failed].include?(e["type"]) }
          answer = events.filter_map { |e| e.dig("item", "text") if e.dig("item", "type") == "agent_message" }.join("\n")
        end
        raise "#{name}: no final response" if answer.to_s.strip.empty?
        expected.each do |path, contents|
          raise "#{name}: wrong #{path}" unless HelmSmoke.read_regular(workspace, path) == contents.b
        end
        if scenario[:fresh]
          owner = HelmSmoke.read_regular(workspace, "AGENTS.md")
          entry = HelmSmoke.read_regular(workspace, "CLAUDE.md")
          raise "#{name}: missing shared layout" unless entry.lines.map(&:strip).include?("@AGENTS.md")
          raise "#{name}: missing project identity" unless owner.include?("## Project Identity")
          raise "#{name}: invented review marker" if owner.include?("last-reviewed:")
          raise "#{name}: wrong config" unless owner.include?("ship-method: direct")
          expected = { "AGENTS.md" => owner, "CLAUDE.md" => entry }
        end
        HelmSmoke.assert_files_unchanged!(workspace, before, expected)
        Array(scenario[:pending]).each { |value| raise "#{name}: pending issue not reported: #{answer}" unless answer.include?(value) }
        if scenario[:no_git]
          raise "#{name}: initialized Git" if workspace.join(".git").exist?
        else
          raise "#{name}: changed HEAD or branches" unless git(workspace, "rev-parse", "HEAD") == before_head && git(workspace, "branch", "--format=%(refname:short)") == "main"
        end
        HelmSmoke.assert_git_unchanged!(workspace, before_git)
        puts "PASS #{client}: #{name} (exact files, preserved inputs and Git state)"
      end
    end
  end
end
