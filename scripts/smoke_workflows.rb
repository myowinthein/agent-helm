# Optional live model checks in disposable repositories. Uses the signed-in CLI accounts.
# These are behavioral checks, separate from offline package validation.
require "digest"
require "fileutils"
require "json"
require "open3"
require "pathname"
require "timeout"
require "tmpdir"
require_relative "smoke_support"

client = ARGV.fetch(0, "codex")
abort "Usage: ruby scripts/smoke_workflows.rb [codex|claude] [case]" unless %w[codex claude].include?(client)
selected = ARGV[1]
root = Pathname(__dir__).parent.realpath
standard = "# Fixture\n\n## Project Config\n\nship-method: direct\ngit-auto-commit: false\nreadme-style: custom\n"
cases = {
  "conflicting-config" => {
    files: HelmSmoke.configuration_conflict(standard).fetch(:files),
    command: "env", request: "Audit the environment configuration.", unchanged: true
  },
  "custom-memory-wrapper" => {
    files: { "CLAUDE.md" => "# Claude entry\n\n@AGENTS.md\n\nKeep this Claude-specific sentence.\n",
             "AGENTS.md" => "# Fixture\n\nProject configuration:\n\n```text\nship-method: direct\ngit-auto-commit: false\nreadme-style: custom\n```\n\n## Team agreements\n\nPreserve this custom section and its heading.\n" },
    command: "log", request: "Run a full project scan.", unchanged: true
  },
  "single-config-owner" => {
    files: { "CLAUDE.md" => standard, "AGENTS.md" => "# Codex instructions\n\nKeep this independent Codex note.\n" },
    command: "env", request: "Audit the environment configuration.", unchanged: true
  },
  "shadowed-adopt-entry" => {
    files: { "CLAUDE.md" => standard, "AGENTS.md" => "# Persistent Codex entry\n",
             "AGENTS.override.md" => "# Temporary override\n\nProject configuration:\n\n```text\nship-method: direct\n```\n" },
    command: "adopt", request: "Install Helm's project rules.", unchanged: true
  },
  "archive-package-path" => {
    files: { "CLAUDE.md" => standard, "prompts/archive/step1-explore.md" => "DECOY: this is a consumer document, not the installed archive procedure.\n" },
    command: "archive", request: "Begin the archive workflow. I have not approved any step yet.", unchanged: true
  },
  "normalize-first-gate" => HelmSmoke.normalize_gate(standard),
  "codex-claude-owner-stop" => {
    files: { "CLAUDE.md" => standard }, command: "adopt",
    request: "Inspect adoption. Preserve the existing instruction owner; no layout change is approved.", unchanged: true
  },
  "codex-foreign-skip" => {
    files: { "AGENTS.md" => standard, "CLAUDE.md" => "@AGENTS.md\n", ".claude/rules/git.md" => "# My Git rules\n\nThese are user-owned rules.\n",
             ".claude/rules/safety.md" => "# My safety rules\n\nThese are user-owned rules.\n" },
    command: "adopt", request: "Keep both foreign files git.md and safety.md unchanged. Skip their replacements and all other installation or connection changes; no writes are approved.", unchanged: true
  },
  # Current managed copies retain their recorded marker on connection.
  "codex-newer-copies" => {
    files: { "AGENTS.md" => standard, "CLAUDE.md" => "@AGENTS.md\n",
             ".claude/rules/git.md" => "<!-- helm-rule: agent-helm@v9.9.9 -->\n" + root.join("rules/git.md").read,
             ".claude/rules/safety.md" => "<!-- helm-rule: agent-helm@v9.9.9 -->\n" + root.join("rules/safety.md").read },
    command: "adopt", request: "Connect Codex and keep the newer project rules. Do not commit or push.", unchanged: false, rules_version: "9.9.9", rule_brand: "agent-helm"
  },
  "codex-external-reference-stop" => {
    files: { "AGENTS.md" => standard + "\n## Rules\n\nRead and follow {fixture_root}/marketplaces/unsupported-source/rules/git.md.\n", "CLAUDE.md" => "@AGENTS.md\n" },
    command: "adopt", request: "Inspect adoption; no external-reference maintenance is approved.", unchanged: true
  }

}
cases.delete_if { |name, _| name.start_with?("codex-") } unless client == "codex"
cases.delete("shadowed-adopt-entry") unless client == "codex"
abort "Unknown case: #{selected}" if selected && !cases.key?(selected)
cases.select! { |name, _| name == selected } if selected

cases.each do |name, scenario|
  HelmSmoke.validate_preconditions!(name, scenario)
  Dir.mktmpdir("helm-#{client}-#{name}-") do |temp|
    workspace = Pathname(temp).join("consumer project")
    workspace.mkpath
    scenario.fetch(:files).merge("README.md" => "# Fictional fixture\n\nA local Markdown project used only for Helm compatibility checks.\n").each do |path, contents|
      file = workspace.join(path)
      file.parent.mkpath
      file.write(contents.gsub("{fixture_root}", workspace.to_s))
    end
    if client == "codex"
      skill = workspace.join(".agents/skills", scenario.fetch(:command))
      skill.parent.mkpath
      skill.make_symlink(root.join("skills", scenario.fetch(:command)))
    end
    HelmSmoke.git(workspace, "init", "--quiet", "--initial-branch=main")
    HelmSmoke.git(workspace, "add", ".")
    HelmSmoke.git(workspace, "-c", "user.name=Helm fixture", "-c", "user.email=fixture@example.invalid", "commit", "--quiet", "-m", scenario.fetch(:initial_message, "chore(fixture): initialize"))
    before = HelmSmoke.snapshot(workspace)
    before_git = HelmSmoke.git_state(workspace)
    approved = {}
    request = scenario.fetch(:request)
    unless scenario.fetch(:unchanged)
      approved["AGENTS.md"] = HelmSmoke.connected_owner(scenario.fetch(:files).fetch("AGENTS.md"))
      version = scenario.fetch(:rules_version, JSON.parse(root.join(".claude-plugin/plugin.json").read).fetch("version"))
      %w[git.md safety.md].each do |rule|
        approved[".claude/rules/#{rule}"] = "<!-- helm-rule: agent-helm@v#{version} -->\n" + root.join("rules", rule).read
      end
      request += "\n\nI approve exactly this final AGENTS.md content; preserve all other content and rule markers:\n```markdown\n#{approved.fetch('AGENTS.md')}```"
    end
    instructions = "This is a disposable Helm compatibility fixture at #{workspace}. Operate only in this fixture and read the selected skill's packaged resources; no network, external services, global configuration changes, or access to other consumer projects. Follow the workflow's questions and approvals. If interactive questions are unavailable, present the pending question in your final response and stop; never invent an answer."
    prompt = if client == "claude"
      "/agent-helm:#{scenario.fetch(:command)} #{request}"
    else
      "Use $#{scenario.fetch(:command)}. #{request}"
    end
    command = if client == "claude"
      ["claude", "--plugin-dir", root.to_s, "--setting-sources", "", "--strict-mcp-config", "--model", "claude-opus-5-5", "--effort", "high",
       "--tools", "Read,Glob,Grep,Bash,Write,Edit", "--allowedTools", "Read,Glob,Grep,Bash,Write,Edit", "--append-system-prompt", instructions,
       "--no-session-persistence", "--output-format", "json", "-p", prompt]
    else
      ["codex", "exec", "--ephemeral", "--sandbox", "workspace-write", "--json", "--cd", workspace.to_s, "#{instructions}\n\n#{prompt}"]
    end
    stdout = stderr = status = nil
    Timeout.timeout(240) { stdout, stderr, status = Open3.capture3(HelmSmoke.environment, *command, chdir: workspace, stdin_data: "") }
    raise "#{name}: #{client} failed: #{stderr.to_s[-2000..]}" unless status.success?
    if client == "claude"
      result = JSON.parse(stdout)
      raise "#{name}: requested Claude model missing" unless result.fetch("modelUsage").key?("claude-opus-5-5")
      raise "#{name}: Claude returned an error" if result["is_error"]
      answer = result.fetch("result")
    else
      events = stdout.lines.filter_map { |line| JSON.parse(line) rescue nil }
      failed = events.find { |event| %w[error turn.failed].include?(event["type"]) }
      raise "#{name}: Codex failed: #{failed}" if failed
      answer = events.filter_map { |event| event.dig("item", "text") if event.dig("item", "type") == "agent_message" }.join("\n")
    end
    raise "#{name}: no final answer" if answer.to_s.strip.empty?
    HelmSmoke.assert_files_unchanged!(workspace, before, approved)
    unless scenario.fetch(:unchanged)
      %w[git.md safety.md].each do |rule|
        path = ".claude/rules/#{rule}"
        raise "#{name}: copied different rules" unless HelmSmoke.read_regular(workspace, path) == approved.fetch(path).b
      end
      raise "#{name}: changed approved shared owner" unless HelmSmoke.read_regular(workspace, "AGENTS.md") == approved.fetch("AGENTS.md").b
      raise "#{name}: missing Claude import" unless HelmSmoke.read_regular(workspace, "CLAUDE.md").include?("@AGENTS.md")
    end
    HelmSmoke.assert_git_unchanged!(workspace, before_git)
    if scenario[:expected_proposal]
      raise "#{name}: corrected message proposal missing" unless answer.include?(scenario.fetch(:expected_proposal))
    end
    raise "#{name}: wrapper owner not identified" if name == "custom-memory-wrapper" && !answer.include?("AGENTS.md")
    if name == "conflicting-config"
      raise "#{name}: configuration conflict not reported: #{answer}" unless %w[CLAUDE.md AGENTS.md direct pr].all? { |value| answer.include?(value) }
    end
    if name == "single-config-owner"
      raise "#{name}: did not reach the read-only audit: #{answer}" unless answer.match?(/ENV (?:AUDIT REPORT|COMPLETE)/i)
    end
    if name == "shadowed-adopt-entry"
      raise "#{name}: shadowing override not reported: #{answer}" unless answer.include?("AGENTS.override.md") && answer.include?("AGENTS.md")
    end
    if %w[codex-newer-copies].include?(name)
      raise "#{name}: no verified adoption report: #{answer}" unless answer.match?(/ADOPT COMPLETE/i)
    end
    if name == "codex-foreign-skip"
      raise "#{name}: foreign Skip not reported: #{answer}" unless answer.match?(/skip/i) && %w[git.md safety.md].all? { |value| answer.include?(value) }
    end
    raise "#{name}: packaged archive report missing" if name == "archive-package-path" && !(answer.include?("Archiving from:") && answer.include?("Project name:"))
    puts "PASS #{client}: #{name} (fixture files, HEAD, and branches verified)"
  end
end
