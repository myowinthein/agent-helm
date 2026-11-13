require "fileutils"
require "open3"
require "rubygems/package"
require "stringio"
require "tmpdir"
require_relative "validate_plugin"

# Returns the validator's rejection message, or nil when it accepts the package.
def validation_failure(installation)
  HelmValidation.validate(installation)
  nil
rescue RuntimeError => error
  error.message
end

root = Pathname(__dir__).parent
HelmValidation.validate(root)
HelmValidation.check(root.glob("commands/**/*.md").empty?, "Remove unused legacy command adapters; shared skills are the only entry points")
HelmValidation.check(JSON.parse(HelmValidation.read(root.join(".claude-plugin/marketplace.json"))).fetch("plugins").none? { |entry| entry.key?("files") },
                     "Remove the ignored marketplace files allowlist")
manifest = JSON.parse(HelmValidation.read(root.join(".claude-plugin/plugin.json")))
HelmValidation.check(manifest.fetch("name") == "agent-helm", "Plugin name must match the project slug")
HelmValidation.check(manifest.fetch("displayName") == "Agent Helm", "Claude must display Agent Helm")
HelmValidation.check(manifest.fetch("interface").fetch("displayName") == manifest.fetch("displayName"), "Codex and Claude must use the same display name")
HelmValidation.check(HelmValidation.read(root.join("README.md")).match?(/^# Agent Helm$/), "README heading must use the product display name")
HelmValidation.check(HelmValidation.frontmatter(root.join("README.md")).fetch("description") == YAML.safe_load_file(root.join("docs/_config.yml")).fetch("description"),
                     "README description must exactly copy the site summary in docs/_config.yml")
HelmValidation.check(manifest.fetch("icon") == "./assets/icon.svg", "Claude must reference the shared SVG icon")
%w[logo composerIcon].each do |field|
  HelmValidation.check(manifest.fetch("interface").fetch(field) == manifest.fetch("icon"), "Claude and Codex must share one icon")
end
HelmValidation.check(HelmValidation.read(root.join("README.md")).include?('src="https://myowinthein.github.io/agent-helm/docs/images/banner.jpg"'), "README banner must use the renamed project URL")

Dir.mktmpdir("helm-package-") do |temp|
  installation = Pathname(temp).join("installed plugin")
  workspace = Pathname(temp).join("consumer workspace")
  installation.mkpath
  workspace.mkpath
  (HelmValidation::COMPONENTS + [".gitattributes"]).each { |component| FileUtils.cp_r(root.join(component), installation) }
  Dir.chdir(workspace) { HelmValidation.validate(installation) }
  HelmValidation.check(workspace.children.empty?, "Package validation wrote to the consumer workspace")

  %w[plugin.json .codex-plugin/plugin.json .agents/plugins/marketplace.json].each do |path|
    alternate = installation.join(path)
    alternate.parent.mkpath
    alternate.write(JSON.generate(manifest))
    failure = validation_failure(installation)
    alternate.delete
    HelmValidation.check(failure == "Keep one shared Claude/Codex manifest and marketplace; alternate metadata can shadow them",
                         "Validator accepted shadowing metadata: #{path}")
  end

  marketplace_path = installation.join(".claude-plugin/marketplace.json")
  original_marketplace = HelmValidation.read(marketplace_path)
  changed_marketplace = JSON.parse(original_marketplace)
  changed_marketplace.fetch("plugins").first["files"] = ["skills/"]
  marketplace_path.write(JSON.generate(changed_marketplace))
  failure = validation_failure(installation)
  marketplace_path.write(original_marketplace)
  HelmValidation.check(failure == "Do not restore the ignored marketplace files allowlist",
                       "Validator accepted an ignored marketplace files allowlist")

  installation.join("commands/nested").mkpath
  legacy = installation.join("commands/nested/unused.md")
  legacy.write("Unused adapter")
  failure = validation_failure(installation)
  legacy.delete
  HelmValidation.check(failure == "Legacy command adapters must not be packaged", "Validator accepted a reintroduced legacy adapter")

  icon = installation.join("assets/icon.svg")
  original = HelmValidation.read(icon)
  {
    "missing" => nil,
    "malformed XML" => "<svg",
    "wrong root" => original.sub("<svg ", "<html ").sub("</svg>", "</html>"),
    "wrong namespace" => original.sub("http://www.w3.org/2000/svg", "https://example.com"),
    "non-square" => original.sub('height="512"', 'height="256"'),
    "too small" => original.gsub("512", "32"),
    "non-numeric dimensions" => original.sub('width="512"', 'width="512px"'),
    "mismatched viewBox" => original.sub('viewBox="0 0 512 512"', 'viewBox="0 0 256 256"'),
    "embedded bitmap" => original.sub("</svg>", '<image href="data:image/png;base64,AAAA"/></svg>'),
    "script" => original.sub("</svg>", "<script>alert(1)</script></svg>"),
    "event handler" => original.sub("<svg ", '<svg onload="alert(1)" '),
    "external paint" => original.sub('fill="#35251f"', 'fill="url(https://example.com/paint.svg#colour)"'),
    "uppercase paint resource" => original.sub('fill="#35251f"', 'fill="URL(https://example.invalid/paint.svg)"'),
    "escaped paint resource" => original.sub('fill="#35251f"') { 'fill="u\\72l(https://example.invalid/paint.svg)"' },
    "stylesheet import" => original.sub("</svg>", '<style>@import "https://example.invalid/icon.css";</style></svg>'),
    "stylesheet URL import" => original.sub("</svg>", '<style>@import url(https://example.invalid/icon.css);</style></svg>'),
    "prefixed stylesheet" => original.sub("</svg>", '<s:style xmlns:s="http://www.w3.org/2000/svg">@import "icon.css";</s:style></svg>'),
    "uppercase stylesheet" => original.sub("</svg>", '<STYLE>@import "icon.css";</STYLE></svg>'),
    "escaped inline CSS resource" => original.sub('<svg ') { '<svg style="fill:u\\72l(https://example.invalid/paint.svg)" ' },
    "stylesheet processing instruction" => original.sub("<svg ", '<?xml-stylesheet type="text/css" href="https://example.invalid/icon.css"?><svg '),
    "document type" => '<!DOCTYPE svg [<!ENTITY colour "red">]>' + original,
    "external resource" => original.sub("</svg>", '<use href="https://example.com/icon.svg#spokes"/></svg>'),
    "oversized file" => original.ljust(5 * 1024 * 1024 + 1, " ")
  }.each do |label, bytes|
    bytes ? icon.binwrite(bytes) : icon.delete
    failure = validation_failure(installation)
    icon.binwrite(original)
    expected = case label
    when /stylesheet/ then "Plugin icon must use presentation attributes, not stylesheets"
    when "escaped inline CSS resource" then "Plugin icon must use presentation attributes, not inline CSS"
    when "uppercase paint resource", "escaped paint resource" then "Plugin icon must not execute code or load external resources"
    end
    HelmValidation.check(!failure.nil?, "Validator accepted a #{label} plugin icon")
    HelmValidation.check(!expected || failure == expected, "Validator rejected #{label} for the wrong reason")
  end

  %w[rules/design.md prompts/archive/step1-explore.md prompts/shared/question-mechanism.md
     prompts/normalize-review.md helpers/normalize_check.py
     prompts/shared/normalize-handoff.md prompts/shared/review-anchor.md helpers/normalize_handoff.py].each do |path|
    missing = installation.join(path)
    original = missing.read
    missing.delete
    failure = validation_failure(installation)
    missing.write(original)
    HelmValidation.check(failure.to_s.include?("Missing packaged resource"), "Missing supporting prompt was accepted: #{path}")
  end

  workflow = installation.join(HelmValidation.workflow_path("log"))
  original_workflow = workflow.read
  duplicate = installation.join("workflows/log.md")
  duplicate.parent.mkpath
  duplicate.write(original_workflow)
  failure = validation_failure(installation)
  duplicate.delete
  HelmValidation.check(failure == "Do not restore competing legacy workflow sources", "Validator accepted competing command instruction sources")
  {
    "missing QM map" => original_workflow.sub("## Question points", "## Unmapped questions"),
    "missing QM reference" => original_workflow.sub("[question mechanism (QM)](../prompts/shared/question-mechanism.md)", "the native picker"),
    "Claude-only question" => original_workflow + "\nAskUserQuestion:\n",
    "Codex-only question" => original_workflow + "\nrequest_user_input_async\n",
    "native selection field" => original_workflow + "\nmultiSelect: true\n"
  }.each do |label, text|
    workflow.write(text)
    failure = validation_failure(installation)
    workflow.write(original_workflow)
    HelmValidation.check(failure.to_s.start_with?("Workflow must "), "Validator accepted a #{label}")
  end

  runtime_path = installation.join("prompts/shared/runtime.md")
  original_runtime = runtime_path.read
  runtime_path.write(original_runtime.sub("[Question mechanism (QM)](question-mechanism.md)", "native questions"))
  failure = validation_failure(installation)
  runtime_path.write(original_runtime)
  HelmValidation.check(failure == "Shared runtime must load QM before human questions", "Validator accepted an unreachable shared QM")

  link = installation.join("prompts/shared/runtime.md")
  runtime = link.read
  link.delete
  link.make_symlink(workspace.join("outside.md"))
  workspace.join("outside.md").write(runtime)
  failure = validation_failure(installation)
  link.delete
  link.write(runtime)
  workspace.join("outside.md").delete
  HelmValidation.check(failure.to_s.include?("Resource escapes package"), "Escaping package link was accepted")

  # Each guard must reject its own violation with its specific message.
  rejection = lambda do |path, change|
    original = path.read
    path.write(change.call(original))
    validation_failure(installation)
  ensure
    path.write(original)
  end
  edit_json = ->(&change) { ->(text) { JSON.parse(text).tap(&change).then { |value| JSON.pretty_generate(value) } } }
  skill = installation.join("skills/log/SKILL.md")
  policy = installation.join("skills/log/agents/openai.yaml")
  guide = installation.join(HelmValidation.workflow_path("log"))
  missing_link = "Missing packaged resource: prompts/shared/missing.md"
  {
    "implicit Codex invocation" => [policy, ->(text) { text.sub("false", "true") }, "Unexpected Codex skill policy or tool grants: log"],
    "Codex tool grant" => [policy, ->(text) { text + "tools:\n  - Bash\n" }, "Unexpected Codex skill policy or tool grants: log"],
    "skill name differing from its directory" => [skill, ->(text) { text.sub("name: log", "name: other") }, "Skill name does not match its directory: log"],
    "blank skill description" => [skill, ->(text) { text.sub(/^description: .*$/, 'description: ""') }, "Invalid skill description: log"],
    "over-long skill description" => [skill, ->(text) { text.sub(/^description: .*$/, "description: #{'x' * 1025}") }, "Invalid skill description: log"],
    "skill link outside the runtime and workflow" => [skill, ->(text) { text + "\n[extra](../../README.md)\n" }, "Skill must load the runtime and its workflow: log"],
    "broken relative guide link" => [guide, ->(text) { text + "\n[missing](../prompts/shared/missing.md)\n" }, missing_link],
    "missing package_root target" => [guide, ->(text) { text + "\n{package_root}/prompts/shared/missing.md\n" }, missing_link],
    "helper contract schema drift" => [installation.join("helpers/ledger-contract.json"),
                                       edit_json.call { |value| value["owners"]["test"]["schema_version"] = 4 },
                                       "Helper must retain the current test ledger schema"],
    "marketplace version drift" => [marketplace_path, edit_json.call { |value| value["plugins"].first["version"] = "0.0.0" }, "Release metadata drift"],
    "marketplace description drift" => [marketplace_path, edit_json.call { |value| value["plugins"].first["description"] = "Changed" }, "Release metadata drift"],
    "unavailable Codex installation" => [marketplace_path, edit_json.call { |value| value["plugins"].first["policy"]["installation"] = "NOT_AVAILABLE" },
                                         "Plugin is not available to Codex"],
    "command auto-discovery" => [installation.join(".claude-plugin/plugin.json"), edit_json.call { |value| value["commands"] = ["./commands/"] },
                                 "Expose skills only; command auto-discovery creates duplicate entries"]
  }.each do |label, (path, change, message)|
    failure = rejection.call(path, change)
    HelmValidation.check(failure == message, "Validator did not reject #{label} with its own message: #{failure.inspect}")
  end
  {
    "extra skill" => ["skills/extra/SKILL.md", "Expected the same ten skills and workflows"],
    "extra archive step" => ["prompts/archive/step6-extra.md", "Archive steps must stay separate from discoverable entry points"]
  }.each do |label, (relative, message)|
    extra = installation.join(relative)
    extra.parent.mkpath
    extra.write("# Extra\n")
    failure = validation_failure(installation)
    extra.delete
    extra.parent.rmdir if relative.start_with?("skills/")
    HelmValidation.check(failure == message, "Validator did not reject an #{label} with its own message: #{failure.inspect}")
  end

  state_names = %w[refactor-log.json test-log.json normalize-log.json legal-manifest.json]
  %w[.helm .claude/helm .claude].each do |directory|
    state_names.each do |name|
      file = installation.join(directory, name)
      file.parent.mkpath
      file.write('{"fictional":true}')
    end
  end
  installation.join(".claude/settings.local.json").write('{"fictional":true}')
  [["git", "init", "--quiet", installation.to_s], ["git", "-C", installation.to_s, "add", "."]].each do |command|
    output, status = Open3.capture2e(*command)
    HelmValidation.check(status.success?, "Temporary archive setup failed: #{output}")
  end
  tree, status = Open3.capture2("git", "-C", installation.to_s, "write-tree")
  HelmValidation.check(status.success?, "Temporary Git tree could not be written")
  archive, status = Open3.capture2("git", "-C", installation.to_s, "archive", "--format=tar", tree.strip, binmode: true)
  HelmValidation.check(status.success?, "Temporary archive could not be built")
  exported = Pathname(temp).join("exported package")
  exported.mkpath
  names = []
  Gem::Package::TarReader.new(StringIO.new(archive)) do |tar|
    tar.each do |entry|
      names << entry.full_name
      next if entry.directory?
      file = exported.join(entry.full_name)
      file.parent.mkpath
      file.binwrite(entry.read)
    end
  end
  flat_state_paths = state_names.map { |name| ".claude/#{name}" }
  HelmValidation.check(names.none? { |name|
    name.start_with?(".helm/", ".claude/helm/") || flat_state_paths.include?(name) || name == ".claude/settings.local.json"
  }, "Operational data leaked into the Git archive")
  Dir.chdir(workspace) { HelmValidation.validate(exported) }
  HelmValidation.check(workspace.children.empty?, "Relocation tests left consumer files behind")
end

puts "Passed shared-SVG, shared-QM routing, relocated-package, missing-resource, path-containment, and real Git-archive checks."
