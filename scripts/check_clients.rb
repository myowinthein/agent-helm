# Optional native discovery checks. Temporary installation, no model calls or user config changes.
require "fileutils"
require "json"
require "open3"
require "timeout"
require "tmpdir"
require_relative "validate_plugin"

root = Pathname(ARGV.fetch(0, Pathname(__dir__).parent)).realpath
HelmValidation.validate(root)
output, status = Open3.capture2e("claude", "--setting-sources", "", "--plugin-dir", root.to_s, "plugin", "details", "helm")
HelmValidation.check(status.success?, "Claude inventory failed: #{output}")
inventories = output.scan(/^\s+(Skills|Commands) \((\d+)\)\s*([^\n]*)/)
names = inventories.flat_map { |_, count, entries| count.to_i.zero? ? [] : entries.split(", ") }
HelmValidation.check(!inventories.empty? && inventories.sum { |_, count, _| count.to_i } == 10 && names.sort == HelmValidation::NAMES, "Claude exposes missing or duplicate workflows: #{output}")
puts "Claude: exactly ten Helm entries through native plugin discovery."

Dir.mktmpdir("helm-client-check-") do |temp|
  env = { "CODEX_HOME" => File.join(temp, "codex") }
  FileUtils.mkdir_p(env.fetch("CODEX_HOME"))
  [["plugin", "marketplace", "add", root.to_s], ["plugin", "add", "helm@agent-helm"]].each do |args|
    output, status = Timeout.timeout(45) { Open3.capture2e(env, "codex", *args, chdir: temp) }
    HelmValidation.check(status.success?, "Codex temporary install failed: #{output}")
  end
  Open3.popen3(env, "codex", "app-server", chdir: temp) do |input, output_stream, error_stream, waiter|
    drainer = Thread.new { error_stream.read }
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
      HelmValidation.check(plugin.fetch("summary").fetch("name") == "helm", "Codex must keep the technical plugin name")
      HelmValidation.check(plugin.fetch("summary").fetch("interface").fetch("displayName") == "Agent Helm", "Codex must display Agent Helm")
      %w[logo composerIcon].each do |field|
        path = Pathname(plugin.fetch("summary").fetch("interface").fetch(field)).realpath
        HelmValidation.check(path == root.join("assets/icon.svg").realpath, "Codex resolved a different #{field}: #{path}")
      end
      names = plugin.fetch("skills").map { |skill| skill.fetch("name") }
      HelmValidation.check(names.sort == HelmValidation::NAMES.map { |name| "helm:#{name}" }, "Codex exposes missing, duplicate, or migrated command entries: #{names}")
      plugin.fetch("skills").each do |skill|
        path = Pathname(skill.fetch("path")).realpath
        HelmValidation.check(path.to_s.start_with?("#{root}/skills/"), "Codex resolved a different package: #{path}")
      end
      HelmValidation.check(plugin.fetch("hooks").empty? && plugin.fetch("mcpServers").empty?, "Unexpected executable plugin components")
      # plugin/read omits migrated commands; the session catalog must also agree.
      result = request.call(3, "skills/list", { cwds: [temp], forceReload: true })
      catalog = result.fetch("data").fetch(0)
      HelmValidation.check(catalog.fetch("errors").empty?, "Codex discovery errors: #{catalog['errors']}")
      entries = catalog.fetch("skills").select { |skill| skill["pluginId"] == "helm@agent-helm" }
      HelmValidation.check(entries.map { |skill| skill.fetch("name") }.sort == HelmValidation::NAMES.map { |name| "helm:#{name}" },
                           "Codex session exposes missing, duplicate or migrated commands: #{entries.map { |skill| skill['name'] }}")
      entries.each do |skill|
        entry = Pathname(skill.fetch("path"))
        HelmValidation.check(skill.fetch("enabled") && entry.parent.parent.basename.to_s == "skills" &&
                             entry.binread == root.join("skills", entry.parent.basename, "SKILL.md").binread,
                             "Codex must load an enabled shared skill from this package: #{entry}")
      end
      puts "Codex: shared SVG icon and exactly ten enabled commands in the native session catalog."
    ensure
      input.close
      Process.kill("TERM", waiter.pid) if waiter.alive?
      waiter.join(10)
      Process.kill("KILL", waiter.pid) if waiter.alive?
      drainer.join(10)
    end
  end
end
