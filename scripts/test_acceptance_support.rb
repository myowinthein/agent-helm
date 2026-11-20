# Offline positive and negative controls; no model calls or network.
require "fileutils"
require "tmpdir"
require_relative "acceptance_support"
require_relative "test_support"

def claude_events(answer = "Audit complete: .env, API_TOKEN")
  [
    { "type" => "system", "subtype" => "init", "model" => HelmAcceptance::MODEL },
    { "type" => "assistant", "message" => { "model" => HelmAcceptance::MODEL, "content" => [
      { "type" => "tool_use", "id" => "call1", "name" => "Bash", "input" => { "command" => "extract key names" } }] } },
    { "type" => "user", "message" => { "content" => [
      { "type" => "tool_result", "tool_use_id" => "call1", "content" => "API_TOKEN" }] } },
    { "type" => "result", "subtype" => "success", "is_error" => false, "result" => answer,
      "modelUsage" => { HelmAcceptance::MODEL => {} } }
  ]
end

def wire(events)
  events.map { |e| JSON.generate(e) }.join("\n") + "\n"
end

checks = {}
checks["fixed dotenv projection exposes names and classifications without values or execution"] = lambda do
  helper = Pathname(__dir__).parent.join("helpers/env_keys.py")
  canary = "SYNTHETIC_DOTENV_PRIVATE_VALUE"
  Dir.mktmpdir("helm-dotenv-projection-") do |directory|
    target = File.join(directory, "must-not-exist")
    input = "TOKEN=#{canary}\nEMPTY=\nexport EXAMPLE = replace_me\nQUOTED=\"\"\nCOMMENT= # isn't a value\nDUP=one\nDUP=two\nEXEC=$(touch #{target})\n"
    stdout, stderr, status = Open3.capture3("python3", "-I", "-B", helper.to_s, stdin_data: input)
    expect(status.success? && stderr.empty? && !stdout.include?(canary) && !File.exist?(target))
    result = JSON.parse(stdout)
    expect(result["loader_validation"] == false)
    expect(result.fetch("keys").map { |row| row.fetch("key") } == %w[TOKEN EMPTY EXAMPLE QUOTED COMMENT DUP DUP EXEC])
    expect(result.fetch("keys")[1..4].map { |row| row.fetch("classification") } == %w[empty placeholder_like empty empty])
  end
end
checks["fixed dotenv projection skips multiline secret text and refuses incomplete unsafe input"] = lambda do
  helper = Pathname(__dir__).parent.join("helpers/env_keys.py")
  canary = "SYNTHETIC_MULTILINE_PRIVATE_VALUE"
  input = "PRIVATE=\"first line\n#{canary}=\nlast line\" # comment\nAFTER=ok\n"
  stdout, stderr, status = Open3.capture3("python3", "-I", "-B", helper.to_s, stdin_data: input)
  expect(status.success? && stderr.empty? && !stdout.include?(canary))
  expect(JSON.parse(stdout).fetch("keys").map { |row| row.fetch("key") } == %w[PRIVATE AFTER])
  ["PRIVATE=\"#{canary}\n", "#{canary}\n", "VALUE=one\\\n#{canary}=\n", "\xff".b,
   "#" * (1024 * 1024 + 1), (1..2000).map { |i| "KEY_#{i}=#{canary}\n" }.join].each do |raw|
    out, error, state = Open3.capture3("python3", "-I", "-B", helper.to_s, stdin_data: raw)
    expect(state.exitstatus == 2 && out.empty? && !error.include?(canary))
    expect(JSON.parse(error).key?("error"))
  end
end
checks["inline-program trace controls allow fixed tools and reject generated interpreter bodies"] = lambda do
  safe = HelmAcceptance.trace("claude", wire(claude_events))
  ["git status --short", "rg --only-matching KEY -- config.php", "python3 -I -B /package/helpers/env_keys.py < .env",
   "python3 -m uuid", "python3 -I -B /package/helpers/helm.py ledger-view <<'JSON'\n{}\nJSON"].each do |command|
    safe[:calls][0]["input"] = { "command" => command }
    HelmAcceptance.assert_no_inline_programs!(safe)
  end
  ["python3 - <<'PY'\nprint(1)\nPY", "python3 -I -B <<'PY'\nprint(1)\nPY",
   "python3 -c 'print(1)'", "node --eval 'process.exit()'", "ruby -e 'puts 1'", "bash -c 'while true; do :; done'"].each do |command|
    safe[:calls][0]["input"] = { "command" => command }
    rejects { HelmAcceptance.assert_no_inline_programs!(safe) }
  end
end
checks["complete exposed Claude tool stream is required"] = lambda do
  events = claude_events
  parsed = HelmAcceptance.trace("claude", wire(events))
  expect(parsed[:calls].length == 1 && parsed[:answer].include?("API_TOKEN"))
  expect(parsed[:calls][0]["output"] == "API_TOKEN")
  rejects { HelmAcceptance.trace("claude", wire(events.reject { |e| e["type"] == "user" })) }
  rejects { HelmAcceptance.trace("claude", wire(events[0...-1])) }
  rejects { HelmAcceptance.trace("claude", wire(events[1..])) }
  events[2]["message"]["content"] *= 2
  rejects { HelmAcceptance.trace("claude", wire(events)) }
end
checks["malformed failed wrong-model and empty traces never pass"] = lambda do
  ["", "not json\n", wire(claude_events) + "partial"].each { |raw| rejects { HelmAcceptance.trace("claude", raw) } }
  %w[model failure empty].each do |mutation|
    events = claude_events
    events.first["model"] = "wrong-model" if mutation == "model"
    events.last["is_error"] = true if mutation == "failure"
    events.last["result"] = "" if mutation == "empty"
    rejects { HelmAcceptance.trace("claude", wire(events)) }
  end
end
checks["normalize waits before history state and remote investigation"] = lambda do
  canary = "SYNTHETIC_HISTORY_#{'7' * 40}"
  safe = HelmAcceptance.trace("claude", wire(claude_events("Team ready / Stop")))
  safe[:calls][0]["input"] = { "command" => "git rev-parse HEAD" }
  HelmAcceptance.assert_normalize_waiting!(safe, history_canary: canary)
  ["git rev-list HEAD", "git log -1", "git cat-file --batch", "git ls-remote origin",
   "python3 helpers/normalize_check.py check", "cat .helm/normalize-log.json"].each do |command|
    changed = safe.merge(calls: [{ "input" => { "command" => command } }])
    rejects { HelmAcceptance.assert_normalize_waiting!(changed, history_canary: canary) }
  end
  rejects { HelmAcceptance.assert_normalize_waiting!(safe.merge(raw: safe[:raw] + canary), history_canary: canary) }
end
checks["leak controls catch tool result assistant stderr partial and encoded values"] = lambda do
  canary = "SYNTHETIC_ONLY_Ac9D0f71K2m8q7W4"
  safe = HelmAcceptance.trace("claude", wire(claude_events))
  HelmAcceptance.assert_no_canary!(safe, canary)
  [canary, canary[6, 12], Base64.strict_encode64(canary), canary.unpack1("H*")].each do |leak|
    events = claude_events
    events[2]["message"]["content"][0]["content"] = leak
    rejects { HelmAcceptance.assert_no_canary!(HelmAcceptance.trace("claude", wire(events)), canary) }
    rejects { HelmAcceptance.assert_no_canary!(HelmAcceptance.trace("claude", wire(claude_events(leak))), canary) }
    rejects { HelmAcceptance.assert_no_canary!(HelmAcceptance.trace("claude", wire(claude_events), leak), canary) }
  end
  # Decode JSON strings as well as searching raw bytes.
  escaped = wire(claude_events(canary)).gsub(canary, canary.bytes.map { |n| format('\\u%04x', n) }.join)
  rejects { HelmAcceptance.assert_no_canary!(HelmAcceptance.trace("claude", escaped), canary) }
end
checks["source-only preview guard rejects explicit canonical and old state paths"] = lambda do
  HelmAcceptance.assert_no_state_access!(HelmAcceptance.trace("claude", wire(claude_events)))
  ["cat .helm/refactor-log.json", "cat .claude/helm/refactor-log.json", "cat .claude/refactor-log.json", "python3 -I -B /package/helpers/helm.py ledger-check"].each do |command|
    events = claude_events
    events[1]["message"]["content"][0]["input"]["command"] = command
    rejects { HelmAcceptance.assert_no_state_access!(HelmAcceptance.trace("claude", wire(events))) }
  end
end
checks["blocked entry permits metadata but rejects continued investigation and action tables"] = lambda do
  canary = "SYNTHETIC_BLOCKED_#{'b7' * 20}"
  safe = HelmAcceptance.trace("claude", wire(claude_events("Blocked: untracked pending-work.txt. Resolve the pending work and rerun.")))
  safe[:calls][0]["input"] = { "command" => "git status --porcelain=v1; git symbolic-ref --short HEAD" }
  HelmAcceptance.assert_entry_blocked!(safe, canary: canary)
  ["cat app.py", "sed -n '1,40p' README.md", "rg --files", "git ls-files", "git log -1",
   "git ls-remote origin", "gh api repos/fixture/fixture", "cat .helm/test-log.json", "git checkout main"].each do |command|
    changed = safe.merge(calls: [{ "input" => { "command" => command } }])
    rejects { HelmAcceptance.assert_entry_blocked!(changed, canary: canary) }
  end
  ["| File | Suggested action | Reason |", "Full scan / Gap scan", canary].each do |answer|
    changed = HelmAcceptance.trace("claude", wire(claude_events(answer)))
    changed[:calls][0]["input"] = { "command" => "git status --porcelain=v1" }
    rejects { HelmAcceptance.assert_entry_blocked!(changed, canary: canary) }
  end
end
checks["Codex requires completed commands and a completed turn"] = lambda do
  item = { "id" => "cmd1", "type" => "command_execution", "command" => "extract keys", "status" => "completed", "aggregated_output" => "API_TOKEN", "exit_code" => 0 }
  events = [{ "type" => "thread.started" }, { "type" => "item.started", "item" => item },
            { "type" => "item.completed", "item" => item },
            { "type" => "item.completed", "item" => { "type" => "agent_message", "text" => "Audit complete" } },
            { "type" => "turn.completed" }]
  expect(HelmAcceptance.trace("codex", wire(events))[:calls].length == 1)
  rejects { HelmAcceptance.trace("codex", wire(events[0...-1])) }
  rejects { HelmAcceptance.trace("codex", wire(events.reject { |e| e["type"] == "item.completed" && e.dig("item", "id") == "cmd1" })) }
  item.delete("aggregated_output")
  rejects { HelmAcceptance.trace("codex", wire(events)) }
end
%w[writing design interaction].each do |selected|
  checks["#{selected}-only exact output excludes unselected rules"] = lambda do
    owner = "# Fixture\n"
    connected = HelmSmoke.connected_owner(owner, rules: [selected])
    expect(connected.include?("#{selected}.md"))
    expect((%w[git safety writing design interaction] - [selected]).none? { |name| connected.include?("#{name}.md") })
    Dir.mktmpdir("helm-selected-rules-") do |temporary|
      root = Pathname(temporary)
      root.join("AGENTS.md").write(owner)
      root.join("git.md").write("Custom Git policy\n")
      before = HelmSmoke.snapshot(root)
      root.join("AGENTS.md").write(connected)
      HelmSmoke.assert_files_unchanged!(root, before, "AGENTS.md" => connected)
      root.join("git.md").write("Lost custom policy\n")
      rejects { HelmSmoke.assert_files_unchanged!(root, before, "AGENTS.md" => connected) }
    end
  end
end
checks["private fixture maps preserve every exact ID pair and reject duplicates"] = lambda do
  old, new_id = "1" * 40, "2" * 40
  expected = { old => new_id }
  [expected, [[old, new_id]], [{ "old" => old, "new" => new_id, "note" => "retained private evidence" }], [{"old_sha"=>old,"new_sha"=>new_id}]].each do |value|
    expect(HelmAcceptance.map_pairs(value) == expected)
  end
  [ [[old,new_id],[old,new_id]], [{"old"=>old}], [{"old"=>old,"old_id"=>old,"new"=>new_id}], {old=>"not an ID"}, true ].each do |value|
    rejects { HelmAcceptance.map_pairs(value) }
  end
end
checks["native guard directories never mask changed package bytes or extra files"] = lambda do
  Dir.mktmpdir("helm-native-guards-") do |temporary|
    package = Pathname(temporary)
    package.join("prompts/shared").mkpath
    package.join("README.md").write("Protected package bytes\n")
    before = HelmSmoke.snapshot(package)
    package.join(".claude/.cc-writes").mkpath
    package.join("prompts/shared/.claude/.cc-writes").mkpath
    HelmAcceptance.assert_fixture_files!(package, before)
    extra = package.join(".claude/.cc-writes/unapproved")
    extra.write("Unexpected output\n")
    rejects { HelmAcceptance.assert_fixture_files!(package, before) }
    extra.delete
    package.join("rogue.claude/.cc-writes").mkpath
    rejects { HelmAcceptance.assert_fixture_files!(package, before) }
    package.join("rogue.claude/.cc-writes").rmdir
    package.join("rogue.claude").rmdir
    package.join("README.md").write("Changed package bytes\n")
    rejects { HelmAcceptance.assert_fixture_files!(package, before) }
  end
end
checks["timeout terminates the owned process"] = lambda do
  Dir.mktmpdir("helm-timeout-") do |temporary|
    begin
      HelmAcceptance.capture({}, [RbConfig.ruby, "-e", "File.write('pid', Process.pid.to_s); sleep 10"], temporary, seconds: 0.3)
      raise "Timeout did not fire"
    rescue RuntimeError => error
      expect(error.message == "Model run timed out; process group terminated")
    end
    pid = Integer(File.read(File.join(temporary, "pid")))
    begin
      Process.kill(0, pid)
      raise "Timed-out process is still running"
    rescue Errno::ESRCH
      # Reaped by the capture helper, not abandoned in the background.
    end
  end
end
checks["live Claude settings keep the sandbox, write denials and pinned tools"] = lambda do
  package, home, remote = Pathname("/fixture/package"), Pathname("/fixture/home"), Pathname("/fixture/remote.git")
  command = HelmAcceptance.claude_command(package, "instructions", "prompt", additional_writes: [home], additional_reads: [remote, home])
  option = ->(name) { command.fetch(command.index(name) + 1) }
  settings = JSON.parse(option.call("--settings"))
  sandbox = settings.fetch("sandbox")
  expect(sandbox.values_at("enabled", "failIfUnavailable", "allowUnsandboxedCommands") == [true, true, false])
  expect(sandbox.dig("filesystem", "denyWrite") == [package.to_s, remote.to_s])
  expect(sandbox.dig("filesystem", "allowWrite") == [home.to_s])
  expect(sandbox.fetch("network").values_at("allowedDomains", "strictAllowlist", "allowLocalBinding") == [[], true, false])
  expect(settings.dig("permissions", "blockReadsOutsideWorkingDirectories") == true)
  expect([option.call("--tools"), option.call("--allowedTools"), option.call("--model")] == ["Bash", "Bash", HelmAcceptance::MODEL])
  expect(option.call("--setting-sources") == "" && %w[--safe-mode --no-session-persistence --strict-mcp-config].all? { |flag| command.include?(flag) })
end
checks.each { |name, check| check.call; puts "PASS acceptance support: #{name}" }
puts "Passed #{checks.length} offline acceptance-support groups; no model calls."
