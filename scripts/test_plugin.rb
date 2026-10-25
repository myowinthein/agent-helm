require "fileutils"
require "open3"
require "rubygems/package"
require "stringio"
require "tmpdir"
require_relative "validate_plugin"

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
    rejected = begin
      HelmValidation.validate(installation)
      false
    rescue RuntimeError => error
      error.message == "Keep one shared Claude/Codex manifest and marketplace; alternate metadata can shadow them"
    ensure
      alternate.delete
    end
    HelmValidation.check(rejected, "Validator accepted shadowing metadata: #{path}")
  end

  marketplace_path = installation.join(".claude-plugin/marketplace.json")
  original_marketplace = HelmValidation.read(marketplace_path)
  changed_marketplace = JSON.parse(original_marketplace)
  changed_marketplace.fetch("plugins").first["files"] = ["skills/"]
  marketplace_path.write(JSON.generate(changed_marketplace))
  rejected = begin
    HelmValidation.validate(installation)
    false
  rescue RuntimeError => error
    error.message == "Do not restore the ignored marketplace files allowlist"
  ensure
    marketplace_path.write(original_marketplace)
  end
  HelmValidation.check(rejected, "Validator accepted an ignored marketplace files allowlist")

  installation.join("commands/nested").mkpath
  legacy = installation.join("commands/nested/unused.md")
  legacy.write("Unused adapter")
  rejected = begin
    HelmValidation.validate(installation)
    false
  rescue RuntimeError => error
    error.message == "Legacy command adapters must not be packaged"
  ensure
    legacy.delete
  end
  HelmValidation.check(rejected, "Validator accepted a reintroduced legacy adapter")

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
    "document type" => '<!DOCTYPE svg [<!ENTITY colour "red">]>' + original,
    "external resource" => original.sub("</svg>", '<use href="https://example.com/icon.svg#spokes"/></svg>'),
    "oversized file" => original.ljust(5 * 1024 * 1024 + 1, " ")
  }.each do |label, bytes|
    bytes ? icon.binwrite(bytes) : icon.delete
    rejected = begin
      HelmValidation.validate(installation)
      false
    rescue RuntimeError
      true
    end
    HelmValidation.check(rejected, "Validator accepted a #{label} plugin icon")
    icon.binwrite(original)
  end

  missing = installation.join("prompts/archive/step1-explore.md")
  original = missing.read
  missing.delete
  begin
    HelmValidation.validate(installation)
    raise "Missing archive prompt was accepted"
  rescue RuntimeError => error
    raise unless error.message.include?("Missing packaged resource")
  ensure
    missing.write(original)
  end

  link = installation.join("prompts/shared/runtime.md")
  runtime = link.read
  link.delete
  link.make_symlink(workspace.join("outside.md"))
  workspace.join("outside.md").write(runtime)
  begin
    HelmValidation.validate(installation)
    raise "Escaping package link was accepted"
  rescue RuntimeError => error
    raise unless error.message.include?("Resource escapes package")
  ensure
    link.delete
    link.write(runtime)
    workspace.join("outside.md").delete
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

puts "Passed shared-SVG, relocated-package, missing-resource, path-containment, and real Git-archive checks."
