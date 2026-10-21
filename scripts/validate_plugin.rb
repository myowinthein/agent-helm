require "json"
require "pathname"
require "yaml"

module HelmValidation
  NAMES = %w[adopt archive env legal log manifest normalize refactor ship test].freeze
  COMPONENTS = %w[.claude-plugin commands skills workflows prompts rules README.md LICENSE].freeze
  module_function

  def check(condition, message)
    raise message unless condition
  end

  def read(path)
    text = Pathname(path).read(encoding: "UTF-8")
    check(text.valid_encoding?, "Invalid UTF-8: #{path}")
    text
  end

  def resource(root, path)
    file = root.join(path).cleanpath
    check(file.file?, "Missing packaged resource: #{path}")
    check(file.realpath.to_s.start_with?("#{root.realpath}/"), "Resource escapes package: #{path}")
    file
  end

  def frontmatter(path)
    match = read(path).match(/\A---\n(.*?)\n---\n/m)
    check(match, "Missing frontmatter: #{path}")
    YAML.safe_load(match[1])
  end

  def validate(root)
    root = Pathname(root).realpath
    manifest = JSON.parse(read(resource(root, ".claude-plugin/plugin.json")))
    marketplace = JSON.parse(read(resource(root, ".claude-plugin/marketplace.json")))
    check(manifest.fetch("name") == "helm" && marketplace.fetch("name") == "claude-helm", "Existing plugin identities changed")
    check(manifest.fetch("skills") == "./skills/" && manifest.fetch("commands") == [], "Expose skills only; command auto-discovery creates duplicate entries")
    check(manifest.fetch("version").match?(/\A\d+\.\d+\.\d+\z/), "Invalid plugin version")
    entry = marketplace.fetch("plugins").find { |item| item["name"] == manifest["name"] }
    check(entry && entry.fetch("source") == "./", "Marketplace must expose this package")
    check(entry.fetch("version") == manifest["version"] && entry.fetch("description") == manifest["description"], "Release metadata drift")
    check(entry.dig("policy", "installation") == "AVAILABLE", "Plugin is not available to Codex")
    # This legacy field is ignored by current Claude; validate closure independently below.
    check((COMPONENTS - entry.fetch("files").map { |path| path.delete_suffix("/") }).empty?, "Legacy file list omits a runtime component")

    groups = [root.glob("commands/*.md").map { |path| path.basename(".md").to_s },
              root.glob("workflows/*.md").map { |path| path.basename(".md").to_s },
              root.glob("skills/*/SKILL.md").map { |path| path.parent.basename.to_s }]
    check(groups.all? { |names| names.sort == NAMES }, "Expected the same ten commands, skills, and workflows")

    NAMES.each do |name|
      skill = resource(root, "skills/#{name}/SKILL.md")
      command = resource(root, "commands/#{name}.md")
      metadata = frontmatter(skill)
      check(metadata["name"] == name, "Skill name does not match its directory: #{name}")
      description = metadata["description"]
      check(description.is_a?(String) && !description.strip.empty? && description.length <= 1024, "Invalid skill description: #{name}")
      check(frontmatter(command)["description"] == description, "Claude description changed independently: #{name}")
      links = read(skill).scan(/\[[^\]]+\]\(([^)]+)\)/).flatten
      targets = links.map { |link| resource(root, skill.parent.join(link).relative_path_from(root)).realpath }
      check(targets.sort == [root.join("prompts/shared/runtime.md"), root.join("workflows/#{name}.md")].sort, "Skill must load the runtime and its workflow: #{name}")
      body = read(command).sub(/\A---\n.*?\n---\n/m, "").strip
      check(body.lines.length <= 3 && body.include?("${CLAUDE_PLUGIN_ROOT}/skills/#{name}/SKILL.md") && body.include?("$ARGUMENTS"), "Adapter duplicates behavior or drops arguments: #{name}")
      policy = YAML.safe_load(read(resource(root, "skills/#{name}/agents/openai.yaml")))
      check(policy == { "policy" => { "allow_implicit_invocation" => false } }, "Unexpected Codex skill policy or tool grants: #{name}")
      check(!metadata.key?("allowed-tools") && !metadata.key?("model") && !metadata.key?("disable-model-invocation"), "Do not change Claude permissions, model, or invocation policy in extraction: #{name}")
    end

    root.glob("{skills,prompts}/**/*.md").each do |file|
      read(file).scan(/\[[^\]]+\]\(([^)]+)\)/).flatten.each do |link|
        next if link.match?(%r{\A(?:https?://|#)})
        resource(root, file.parent.join(link.split("#").first).relative_path_from(root))
      end
    end
    root.glob("workflows/*.md").each do |file|
      read(file).scan(%r{\{package_root\}/([\w./-]+\.md)}).flatten.each { |path| resource(root, path) }
    end
    check(root.glob("prompts/archive/step*.md").length == 5, "Archive steps must stay separate from discoverable entry points")
    %w[rules/git.md rules/safety.md prompts/shared/runtime.md].each { |path| resource(root, path) }
    true
  end
end

if $PROGRAM_NAME == __FILE__
  HelmValidation.validate(ARGV.fetch(0, Pathname(__dir__).parent))
  puts "Validated ten shared Helm workflows, entry points, metadata, and resource links."
end
