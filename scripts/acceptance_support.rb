# Bounded live-trace assertions. Requiring this file executes no client or workflow.
require "base64"
require "json"
require "timeout"
require_relative "smoke_support"

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
