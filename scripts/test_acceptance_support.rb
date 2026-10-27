# Offline positive and negative controls; no model calls or network.
require "fileutils"
require "tmpdir"
require_relative "acceptance_support"

def expect(condition)
  raise "Acceptance assertion failed" unless condition
end

def rejects
  begin
    yield
  rescue RuntimeError
    return
  end
  raise "Expected acceptance guard to reject"
end

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
  safe = HelmAcceptance.trace("claude", wire(claude_events("Team ready / Review only / Stop")))
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
checks["writing-only exact output excludes unselected rules"] = lambda do
  owner = "# Fixture\n"
  connected = HelmSmoke.connected_owner(owner, rules: ["writing"])
  expect(connected.include?("writing.md") && !connected.include?("git.md") && !connected.include?("safety.md"))
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
checks.each { |name, check| check.call; puts "PASS acceptance support: #{name}" }
puts "Passed #{checks.length} offline acceptance-support groups; no model calls."
