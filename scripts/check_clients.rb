# Optional native discovery checks. No installation, model calls, or user config changes.
require "json"
require "open3"
require "tempfile"
require "timeout"
require_relative "validate_plugin"

root = Pathname(ARGV.fetch(0, Pathname(__dir__).parent)).realpath
HelmValidation.validate(root)
output, status = Open3.capture2e("claude", "--setting-sources", "", "--plugin-dir", root.to_s, "plugin", "details", "helm")
HelmValidation.check(status.success?, "Claude inventory failed: #{output}")
inventories = output.scan(/^\s+(Skills|Commands) \((\d+)\)\s*([^\n]*)/)
names = inventories.flat_map { |_, count, entries| count.to_i.zero? ? [] : entries.split(", ") }
HelmValidation.check(!inventories.empty? && inventories.sum { |_, count, _| count.to_i } == 10 && names.sort == HelmValidation::NAMES, "Claude exposes missing or duplicate workflows: #{output}")
puts "Claude: exactly ten Helm entries through native plugin discovery."

Tempfile.create("helm-app-server-errors") do |errors|
  Open3.popen3("codex", "app-server", "--stdio") do |input, output_stream, error_stream, waiter|
    drainer = Thread.new { IO.copy_stream(error_stream, errors) }
    request = lambda do |id, method, params|
      input.puts(JSON.generate({ jsonrpc: "2.0", id: id, method: method, params: params }))
      input.flush
      Timeout.timeout(45) do
        loop do
          line = output_stream.gets
          raise "Codex app-server closed before #{method}" unless line
          result = JSON.parse(line)
          next unless result["id"] == id
          raise "Codex #{method} failed: #{result['error']}" if result["error"]
          break result.fetch("result")
        end
      end
    end
    begin
      request.call(1, "initialize", { clientInfo: { name: "helm_discovery_check", version: "1.0.0" }, capabilities: { experimentalApi: true } })
      input.puts(JSON.generate({ jsonrpc: "2.0", method: "initialized" }))
      input.flush
      result = request.call(2, "plugin/read", { marketplacePath: root.join(".claude-plugin/marketplace.json").to_s, pluginName: "helm" })
      plugin = result.fetch("plugin")
      names = plugin.fetch("skills").map { |skill| skill.fetch("name") }
      HelmValidation.check(names.sort == HelmValidation::NAMES.map { |name| "helm:#{name}" }, "Codex exposes missing, duplicate, or migrated command entries: #{names}")
      plugin.fetch("skills").each do |skill|
        path = Pathname(skill.fetch("path")).realpath
        HelmValidation.check(path.to_s.start_with?("#{root}/skills/"), "Codex resolved a different package: #{path}")
      end
      HelmValidation.check(plugin.fetch("hooks").empty? && plugin.fetch("mcpServers").empty?, "Unexpected executable plugin components")
      puts "Codex: exactly ten namespaced skills through native marketplace reading."
    ensure
      input.close
      Process.kill("TERM", waiter.pid) if waiter.alive?
      waiter.join(10)
      Process.kill("KILL", waiter.pid) if waiter.alive?
      drainer.join(10)
    end
  end
end
