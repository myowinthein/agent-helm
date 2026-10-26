require "json"
require "pathname"
require "rexml/document"
require "yaml"

module HelmValidation
  NAMES = %w[adopt archive env legal log manifest normalize refactor ship test].freeze
  COMPONENTS = %w[.claude-plugin assets skills workflows prompts rules helpers README.md LICENSE].freeze
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
    %w[plugin.json .codex-plugin/plugin.json .agents/plugins/marketplace.json].each do |path|
      check(!root.join(path).exist? && !root.join(path).symlink?,
            "Keep one shared Claude/Codex manifest and marketplace; alternate metadata can shadow them")
    end
    manifest = JSON.parse(read(resource(root, ".claude-plugin/plugin.json")))
    marketplace = JSON.parse(read(resource(root, ".claude-plugin/marketplace.json")))
    check(manifest.fetch("name") == "agent-helm" && marketplace.fetch("name") == "agent-helm-marketplace", "Expected plugin agent-helm in marketplace agent-helm-marketplace")
    check(manifest.fetch("skills") == "./skills/" && manifest.fetch("commands") == [], "Expose skills only; command auto-discovery creates duplicate entries")
    check(root.glob("commands/**/*.md").empty?, "Legacy command adapters must not be packaged")
    check(manifest.fetch("version").match?(/\A\d+\.\d+\.\d+\z/), "Invalid plugin version")
    entry = marketplace.fetch("plugins").find { |item| item["name"] == manifest["name"] }
    check(entry && entry.fetch("source") == "./", "Marketplace must expose this package")
    check(entry.fetch("version") == manifest["version"] && entry.fetch("description") == manifest["description"], "Release metadata drift")
    check(entry.dig("policy", "installation") == "AVAILABLE", "Plugin is not available to Codex")
    check(!entry.key?("files"), "Do not restore the ignored marketplace files allowlist")

    icon = resource(root, manifest.fetch("icon"))
    %w[logo composerIcon].each do |field|
      check(manifest.fetch("interface").fetch(field) == manifest.fetch("icon"), "Claude and Codex must reference the same icon file")
    end
    check(icon.extname == ".svg" && icon.size <= 5 * 1024 * 1024, "Plugin icon must be an SVG no larger than 5 MiB")
    begin
      document = REXML::Document.new(read(icon))
    rescue REXML::ParseException
      raise "Invalid plugin icon SVG XML"
    end
    svg = document.root
    check(svg && svg.name == "svg" && svg.namespace == "http://www.w3.org/2000/svg", "Invalid plugin icon SVG root")
    dimensions = %w[width height].map { |field| svg.attributes[field].to_s }
    check(dimensions.all? { |value| value.match?(/\A\d+(?:\.\d+)?\z/) && value.to_f.finite? && value.to_f >= 48 } &&
          dimensions.map(&:to_f).uniq.length == 1, "Plugin icon must have square numeric dimensions of at least 48 pixels")
    check(svg.attributes["viewBox"] == "0 0 #{dimensions.join(' ')}", "Plugin icon viewBox must match its dimensions")
    check(document.doctype.nil?, "Plugin icon must not declare external entities")
    document.elements.each("//*") do |element|
      check(!%w[image script foreignObject].include?(element.name), "Plugin icon must contain only static vector artwork")
      element.attributes.each_attribute do |attribute|
        check(!attribute.name.start_with?("on") && attribute.name != "href" && !attribute.value.include?("url("),
              "Plugin icon must not execute code or load external resources")
      end
    end

    groups = [root.glob("workflows/*.md").map { |path| path.basename(".md").to_s },
              root.glob("skills/*/SKILL.md").map { |path| path.parent.basename.to_s }]
    check(groups.all? { |names| names.sort == NAMES }, "Expected the same ten skills and workflows")

    NAMES.each do |name|
      workflow = read(resource(root, "workflows/#{name}.md"))
      check(workflow.include?("## Question points") && workflow.include?("[QM](../prompts/shared/question-mechanism.md)"),
            "Workflow must map its question points to shared QM: #{name}")
      check(!workflow.match?(/\b(?:AskUserQuestion|request_user_input(?:_async)?|multiSelect)\b/),
            "Workflow must use shared QM instead of native question fields: #{name}")
      skill = resource(root, "skills/#{name}/SKILL.md")
      metadata = frontmatter(skill)
      check(metadata["name"] == name, "Skill name does not match its directory: #{name}")
      description = metadata["description"]
      check(description.is_a?(String) && !description.strip.empty? && description.length <= 1024, "Invalid skill description: #{name}")
      links = read(skill).scan(/\[[^\]]+\]\(([^)]+)\)/).flatten
      targets = links.map { |link| resource(root, skill.parent.join(link).relative_path_from(root)).realpath }
      check(targets.sort == [root.join("prompts/shared/runtime.md"), root.join("workflows/#{name}.md")].sort, "Skill must load the runtime and its workflow: #{name}")
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
    %w[rules/git.md rules/safety.md rules/writing.md prompts/shared/runtime.md prompts/shared/project-state.md
       prompts/shared/question-mechanism.md].each { |path| resource(root, path) }
    check(read(root.join("prompts/shared/runtime.md")).include?("[Question mechanism (QM)](question-mechanism.md)"),
          "Shared runtime must load QM before human questions")
    %w[helpers/helm.py helpers/helm_lib/__init__.py helpers/helm_lib/common.py helpers/helm_lib/ledger.py
       helpers/ledger-contract.json prompts/shared/ledger-helper.md helpers/normalize_check.py
       prompts/normalize-review.md].each { |path| resource(root, path) }
    contract = JSON.parse(read(resource(root, "helpers/ledger-contract.json")))
    check(contract.fetch("interface_version") == 1 && contract.fetch("owners").keys.sort == %w[refactor test],
          "Expected one read-only refactor/test helper interface")
    %w[refactor test].zip([2, 3]).each do |owner, version|
      check(contract.fetch("owners").fetch(owner).fetch("schema_version") == version,
            "Helper must retain the current #{owner} ledger schema")
    end
    true
  end
end

if $PROGRAM_NAME == __FILE__
  HelmValidation.validate(ARGV.fetch(0, Pathname(__dir__).parent))
  puts "Validated ten shared Helm workflows, entry points, metadata, and resource links."
end
