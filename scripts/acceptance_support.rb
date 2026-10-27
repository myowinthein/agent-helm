# Trace handling and acceptance oracles. Requiring this file executes no client or workflow.
require "base64"
require "json"
require "timeout"
require_relative "smoke_support"
require_relative "git_acceptance"

module HelmAcceptance
  MODEL = "claude-sonnet-5-5"
  MAX_TRACE = 4 * 1024 * 1024
  module_function

  def trace(client, stdout, stderr = "", model: MODEL)
    raise "Incomplete or oversized model trace" if stdout.bytesize > MAX_TRACE || stderr.bytesize > MAX_TRACE
    events = stdout.lines.reject { |line| line.strip.empty? }.map { |line| JSON.parse(line) }
    raise "Empty model trace" if events.empty? || events.any? { |e| !e.is_a?(Hash) }
    if client == "claude"
      init = events.find { |e| e["type"] == "system" && e["subtype"] == "init" }
      result = events.last
      assistants = events.select { |e| e["type"] == "assistant" }
      unless init && init["model"] == model && !assistants.empty? &&
             assistants.all? { |e| e.dig("message", "model") == model } &&
             result["type"] == "result" && result["subtype"] == "success" && !result["is_error"] &&
             result.fetch("modelUsage", {}).keys == [model]
        raise "Incomplete, failed or unexpected-model Claude trace"
      end
      uses = assistants.flat_map { |e| e.dig("message", "content") || [] }.select { |b| b["type"] == "tool_use" }
      replies = events.select { |e| e["type"] == "user" }.flat_map { |e| e.dig("message", "content") || [] }
                      .select { |b| b["type"] == "tool_result" }
      unless uses.map { |b| b["id"] }.uniq.length == uses.length &&
             uses.all? { |use| replies.one? { |reply| reply["tool_use_id"] == use["id"] } } &&
             replies.all? { |reply| uses.any? { |use| use["id"] == reply["tool_use_id"] } }
        raise "Incomplete tool-call/result trace"
      end
      answer = result["result"]
      calls = uses.map { |b| { "name" => b["name"], "input" => b["input"], "output" => replies.find { |r| r["tool_use_id"] == b["id"] }["content"] } }
      outputs = replies.map { |b| b["content"] }
    elsif client == "codex"
      unless events.any? { |e| e["type"] == "thread.started" } && events.last["type"] == "turn.completed" &&
             events.none? { |e| %w[error turn.failed].include?(e["type"]) }
        raise "Incomplete or failed Codex trace"
      end
      completed = events.select { |e| e["type"] == "item.completed" }.map { |e| e.fetch("item") }
      started = events.select { |e| e["type"] == "item.started" && e.dig("item", "type") == "command_execution" }
      raise "Incomplete command trace" unless started.all? { |e| completed.any? { |i| i["id"] == e.dig("item", "id") } }
      calls = completed.select { |i| i["type"] == "command_execution" }.map do |item|
        raise "Incomplete command output" unless item["status"] == "completed" && item.key?("aggregated_output") && item.key?("exit_code")
        { "name" => "Bash", "input" => { "command" => item["command"] }, "output" => item["aggregated_output"] }
      end
      answer = completed.select { |i| i["type"] == "agent_message" }.map { |i| i["text"] }.join("\n")
      outputs = completed.select { |i| i["type"] == "command_execution" }.map { |i| i["aggregated_output"] }
    else
      raise "Unsupported trace client"
    end
    raise "Missing model answer" unless answer.is_a?(String) && !answer.strip.empty?
    { events: events, calls: calls, tool_outputs: outputs, answer: answer, raw: stdout + stderr }
  rescue JSON::ParserError, KeyError, TypeError, NoMethodError
    raise "Invalid model trace", cause: nil
  end

  def strings(value)
    case value
    when Hash then value.flat_map { |k, v| [k.to_s, *strings(v)] }
    when Array then value.flat_map { |v| strings(v) }
    when String then [value]
    else []
    end
  end

  def assert_no_canary!(result, canary)
    raise "Canary must be synthetic and at least 24 characters" unless canary.is_a?(String) && canary.length >= 24
    forms = [canary, Base64.strict_encode64(canary), canary.unpack1("H*")]
    # Check partial disclosures as well as full/encoded forms; never echo matches.
    forms.concat((0..canary.length - 12).map { |n| canary[n, 12] })
    exposed = [result.fetch(:raw), *strings(result.fetch(:events))]
    raise "Synthetic canary reached model/tool output" if exposed.any? { |s| forms.any? { |form| s.include?(form) } }
  end

  def assert_no_state_access!(result)
    state = %r{(?:\.helm(?:/|\\)|\.claude(?:/|\\)helm|(?:refactor|test|normalize)-log\.json|legal-manifest\.json|\bledger-(?:check|view)\b|helpers/helm\.py)}i
    raise "Source-only preview accessed state" if result.fetch(:calls).any? { |c| strings(c.fetch("input")).any? { |s| state.match?(s) } }
  end

  def map_pairs(value)
    pairs = if value.is_a?(Hash)
      value.to_a
    elsif value.is_a?(Array)
      value.map do |row|
        if row.is_a?(Array) && row.length == 2
          row
        elsif row.is_a?(Hash)
          old_keys = row.keys.grep(/\A(?:old|original)(?:_(?:id|sha|commit))?\z/)
          new_keys = row.keys.grep(/\A(?:new|rewritten|mapped)(?:_(?:id|sha|commit))?\z/)
          raise "Ambiguous synthetic correspondence fields" unless old_keys.length == 1 && new_keys.length == 1
          [row.fetch(old_keys.first), row.fetch(new_keys.first)]
        else
          raise "Invalid synthetic correspondence rows"
        end
      end
    else
      raise "Invalid synthetic correspondence"
    end
    unless pairs.all? { |pair| pair.all? { |id| id.is_a?(String) && id.match?(/\A(?:[0-9a-f]{40}|[0-9a-f]{64})\z/) } } && pairs.map(&:first).uniq.length == pairs.length
      raise "Invalid or duplicate synthetic correspondence"
    end
    pairs.to_h
  end

  def assert_fixture_files!(root, before, approved = {})
    expected = HelmSmoke.expected_snapshot(before, approved)
    actual = HelmSmoke.snapshot(root)
    # The native client creates empty write-guard directories when a Bash read
    # changes cwd. Only these new, empty directory pairs are bookkeeping.
    extra = actual.keys - expected.keys
    allowed = extra.select do |path|
      next false unless actual[path] == :directory
      if Pathname(path).basename.to_s == ".cc-writes" && Pathname(path).parent.basename.to_s == ".claude"
        actual.keys.none? { |candidate| candidate.start_with?(path + "/") }
      elsif Pathname(path).basename.to_s == ".claude"
        parent = Pathname(path).parent.to_s
        (parent == "." || expected[parent] == :directory) && actual[path + "/.cc-writes"] == :directory &&
          actual.keys.select { |candidate| candidate.start_with?(path + "/") } == [path + "/.cc-writes"]
      else
        false
      end
    end
    raise "Fixture bytes or undeclared paths changed" unless actual.reject { |path, _| allowed.include?(path) } == expected
  end

  # These checks operate only on caller-supplied disposable fixture paths.
  def verify_normalize!(workspace:, container:, scenario:, before:, approved:)
    graph_before = scenario.fetch(:graph_before)
    graph_after = HelmGitAcceptance.graph(workspace)
    mapping = HelmGitAcceptance.derive_mapping(graph_before, graph_after, scenario.fetch(:replacements))
    checkpoint = JSON.parse(HelmSmoke.read_regular(workspace, ".helm/normalize-log.json"))
    first = scenario.fetch(:replacements).keys.fetch(0)
    unless checkpoint["schema_version"] == 2 && checkpoint.fetch("branches").keys == ["main"] &&
           checkpoint.dig("branches", "main", "last_checked_commit") == mapping.fetch(first) &&
           checkpoint.dig("branches", "main", "review_kind") == "semantic"
      raise "Normalize checkpoint overstates the reviewed prefix"
    end
    tip = graph_after.fetch(:refs).fetch("refs/heads/main")
    parents = graph_after.fetch(:commits).fetch(tip).fetch(:headers).grep(/^parent /)
    expected_parent = mapping.fetch(graph_before.fetch(:refs).fetch("refs/heads/main"))
    raise "Unexpected checkpoint ancestry" unless parents == ["parent #{expected_parent}"]
    raise "Unexpected checkpoint diff" unless HelmSmoke.git(workspace, "diff-tree", "--no-commit-id", "--name-only", "-r", tip).lines.map(&:strip) == [".helm/normalize-log.json"]
    core = Marshal.load(Marshal.dump(graph_after))
    core[:refs]["refs/heads/main"] = expected_parent
    core[:index] = graph_before.fetch(:index)
    HelmGitAcceptance.assert_rewrite!(graph_before, core, mapping, scenario.fetch(:replacements))
    evidence = scenario.fetch(:private_path)
    raise "Private proof is not owner-only" unless (evidence.stat.mode & 077) == 0
    saved = JSON.parse(HelmSmoke.read_regular(evidence, "verified-map.json"))
    pairs = begin
      HelmAcceptance.map_pairs(saved)
    rescue RuntimeError
      warn "Synthetic map outer structure: #{saved.class}; keys=#{saved.is_a?(Hash) ? saved.keys.first(5).inspect : 'not an object'}"
      raise
    end
    unless pairs == mapping
      warn "Synthetic map structure: #{saved.class}; keys=#{saved.is_a?(Hash) ? saved.keys.first(5).inspect : 'not an object'}"
      raise "Saved current-run map mismatch"
    end
    if scenario[:require_handoff]
      locator = JSON.parse(HelmSmoke.read_regular(evidence, "before-filter-locator.json"))
      raise "Recovery was not registered before filtering" unless locator.fetch("recovery_directory") == evidence.to_s &&
        locator.fetch("entrypoint") == "handoff.json" && locator.fetch("availability") == "present"
      path = "agent-helm/normalize-handoffs/#{locator.fetch('run_id')}.json"
      current = JSON.parse(HelmSmoke.read_regular(workspace.join(".git"), path))
      raise "Pre-filter locator was changed after rewriting" unless current == locator.reject { |key,_| key == "availability" }
      JSON.parse(HelmSmoke.read_regular(evidence, current.fetch("entrypoint")))
    end
    recovery = container.join("independent recovery")
    recovery.mkpath
    protected_bundle_refs = graph_before[:refs].select { |k,_| k.start_with?("refs/heads/", "refs/tags/") }
    HelmGitAcceptance.verify_bundle!(workspace, evidence.join("recovery.bundle"), graph_before[:refs].select { |k,_| k.start_with?('refs/heads/') }.values, recovery, expected_refs: protected_bundle_refs)
    approved[".helm/normalize-log.json"] = HelmSmoke.read_regular(workspace, ".helm/normalize-log.json")
    HelmAcceptance.assert_fixture_files!(workspace, before, approved)
  end

  def verify_test_lifecycle!(workspace:, package:, scenario:, before:, before_git:, approved:, result:)
    contract = scenario.fetch(:test_fixture)
    ledger = JSON.parse(HelmSmoke.read_regular(workspace, ".helm/test-log.json"))
    finding = ledger.fetch("cases").find { |c| c["id"] == contract.fetch(:id) }
    raise "Synthetic test finding is missing or scope expanded" unless ledger["schema_version"] == 3 && finding && ledger.fetch("cases").length == 1
    raise "A human skip/risk decision was invented" if %w[skip accepted-risk].include?(finding.dig("decision", "type"))
    raise "Backlog-only work advanced scan roots" unless %w[assessed_commit full_scan_commit].all? { |key| ledger[key] == contract.fetch(:source) }
    checked, status = Open3.capture2e("python3", "-I", "-B", package.join("helpers/helm.py").to_s, "ledger-check",
      stdin_data: JSON.generate(interface_version: 1, owner: "test", workspace: workspace.to_s))
    raise "Invalid synthetic test record" unless status.success? && JSON.parse(checked).dig("result", "status") == "valid"
    commits = HelmSmoke.git(workspace, "rev-list", "#{before_git.fetch(:head).strip}..HEAD").lines.map(&:strip)
    if contract.fetch(:successful)
      closure = finding.fetch("closure")
      code = closure.fetch("commit")
      raise "Successful closure lacks actual separate code provenance" unless finding["state"] == "resolved" && closure["method"] == "runtime" && commits.include?(code) && code != commits.first
      raise "Wrong code commit scope" unless HelmSmoke.git(workspace, "diff-tree", "--no-commit-id", "--name-only", "-r", code).lines.map(&:strip) == ["tests/test_greeting.py"]
      raise "Wrong final closure commit scope" unless HelmSmoke.git(workspace, "diff-tree", "--no-commit-id", "--name-only", "-r", "HEAD").lines.map(&:strip) == [".helm/test-log.json"]
      raise "Unexpected successful-test commit scope" unless (2..3).include?(commits.length) && commits.all? { |id| HelmSmoke.git(workspace, "diff-tree", "--no-commit-id", "--name-only", "-r", id).lines.map(&:strip) == [id == code ? "tests/test_greeting.py" : ".helm/test-log.json"] }
      HelmSmoke.git(workspace, "merge-base", "--is-ancestor", code, "HEAD")
      raise "Successful fixture retained source/index drafts" unless HelmSmoke.git(workspace, "status", "--porcelain", "--untracked-files=no").empty?
    else
      raise "Deferred/failed verification falsely closed a case" unless finding["state"] == "open" && !finding.key?("closure")
      raise "Unexpected test/code commit after unverified work" unless commits.length <= 1 && commits.all? { |id| HelmSmoke.git(workspace, "diff-tree", "--no-commit-id", "--name-only", "-r", id).lines.map(&:strip) == [".helm/test-log.json"] }
    end
    approved[".helm/test-log.json"] = HelmSmoke.read_regular(workspace, ".helm/test-log.json")
    HelmAcceptance.assert_fixture_files!(workspace, before, approved)
    if contract.fetch(:deferred)
      raise "Deferred tests were executed" if result.fetch(:calls).any? { |c| HelmAcceptance.strings(c["input"]).any? { |s| s.match?(/\b(?:unittest|pytest)\b/) && s.match?(/\bpython\S*\s+(?:-\S+\s+)*-m\s/) } }
    elsif !contract.fetch(:successful)
      raise "Expected failed verification never ran" unless HelmAcceptance.strings(result.fetch(:tool_outputs)).any? { |s| s.include?("FAILED") && s.include?("TypeError") }
    end
  end

  def verify_publication!(name:, workspace:, scenario:, result:)
    observed = HelmGitAcceptance.remote_refs(workspace, scenario.fetch(:local_remote))
    HelmGitAcceptance.assert_publication!(observed, scenario.fetch(:expected_remote))
    commands = result.fetch(:calls).flat_map { |c| HelmAcceptance.strings(c.fetch("input")) }
    if scenario[:discover_handoff]
      raise "Ship skipped local handoff discovery" unless commands.any? { |text| text.include?("normalize_handoff.py") || text.include?("normalize-handoffs") }
      actual = HelmSmoke.read_regular(workspace.join(".git"), "agent-helm/normalize-handoffs/history-fixture.json")
      raise "Ship changed its immutable locator" unless actual == scenario.fetch(:locator_bytes)
      if scenario[:missing_handoff]
        raise "Missing recovery did not remain pending" unless result.fetch(:answer).match?(/missing|unavailable|pending|not exist/i)
        raise "Ship searched for the moved private backup" if HelmAcceptance.strings(result.fetch(:calls)).any? { |text| text.include?(scenario.fetch(:private_path).to_s) }
      end
    end
    remote_tip = scenario.fetch(:expected_remote).fetch("refs/heads/main")
    inspected = result.fetch(:calls).any? do |call|
      command = HelmAcceptance.strings(call.fetch("input")).join("\n")
      command.match?(/\b(?:ls-remote|show-ref|for-each-ref|rev-parse|cat-file)\b/) &&
        (command.include?("ls-remote") || command.include?(scenario.fetch(:local_remote).to_s)) &&
        HelmAcceptance.strings(call["output"]).any? { |text| text.include?(remote_tip) }
    end
    raise "Actual remote main was not inspected" unless inspected || scenario[:missing_handoff]
    if scenario[:immutable_proof]
      proof = JSON.parse(HelmSmoke.read_regular(scenario.fetch(:private_path), "handoff.json"))
      raise "Original proof or fixed expectations were replaced" unless scenario.fetch(:immutable_proof).all? { |key,value| proof[key] == value }
    end
    if scenario[:expected_updates]
      raise "Fixture recorder hook changed" unless HelmSmoke.read_regular(scenario.fetch(:local_remote), "hooks/pre-receive") == scenario.fetch(:fixture_hook).b
      log = scenario.fetch(:local_remote).join("fixture-updates.log")
      updates = log.file? ? HelmSmoke.read_regular(scenario.fetch(:local_remote), "fixture-updates.log").lines.map(&:strip) : []
      raise "Unexpected fixture publication actions" unless updates == scenario.fetch(:expected_updates)
    end
    if %w[history-remote-moved history-missing-handoff archive-completed-no-replay ship-completed-backup-no-replay].include?(name)
      raise "Moved remote caused a publication attempt" if commands.any? { |c| c.match?(/\bgit\s+push\b/) }
    else
      raise "Partial resume omitted its fixed feature lease" unless commands.any? { |c| c.include?("--force-with-lease=refs/heads/feature:") }
    end
  end

  def capture(environment, command, workspace, seconds: 240)
    stdout = stderr = nil
    status = nil
    Open3.popen3(environment, *command, chdir: workspace, pgroup: true) do |input, output, errors, waiter|
      input.close
      readers = [output, errors].map do |io|
        Thread.new do
          bytes = io.read(MAX_TRACE + 1) || ""
          raise "Model trace exceeded limit" if bytes.bytesize > MAX_TRACE
          bytes
        end
      end
      begin
        Timeout.timeout(seconds) do
          stdout, stderr = readers.map(&:value)
          status = waiter.value
        end
      ensure
        if waiter.alive?
          Process.kill("TERM", -waiter.pid) rescue Errno::ESRCH
          unless waiter.join(2)
            Process.kill("KILL", -waiter.pid) rescue Errno::ESRCH
            waiter.join
          end
        end
        readers.each { |thread| thread.join(2) }
      end
    end
    raise "Model execution failed; trace withheld" unless status.success?
    [stdout, stderr]
  rescue Timeout::Error
    raise "Model run timed out; process group terminated", cause: nil
  end

  def claude_command(root, instructions, prompt, budget: "1", additional_writes: [], additional_reads: [])
    # These settings apply only to this invocation, never the user's installations.
    settings = { sandbox: { enabled: true, failIfUnavailable: true, allowUnsandboxedCommands: false,
                            excludedCommands: [], filesystem: { denyWrite: [root.to_s, *(additional_reads - additional_writes).map(&:to_s)], allowWrite: additional_writes.map(&:to_s) },
                            network: { allowedDomains: [], strictAllowlist: true, allowLocalBinding: false } },
                 permissions: { blockReadsOutsideWorkingDirectories: true } }
    ["claude", "--safe-mode", "--add-dir", root.to_s, *(additional_writes + additional_reads).uniq.map(&:to_s),
     "--setting-sources", "", "--settings", JSON.generate(settings),
     "--strict-mcp-config", "--mcp-config", '{"mcpServers":{}}', "--no-chrome",
     "--model", MODEL, "--effort", "high", "--max-budget-usd", budget,
     "--tools", "Bash", "--allowedTools", "Bash", "--append-system-prompt", instructions,
     "--no-session-persistence", "--output-format", "stream-json", "--verbose", "-p", prompt]
  end
end
