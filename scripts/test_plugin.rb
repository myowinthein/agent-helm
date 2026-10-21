require "fileutils"
require "open3"
require "rubygems/package"
require "stringio"
require "tmpdir"
require_relative "validate_plugin"

root = Pathname(__dir__).parent
HelmValidation.validate(root)

Dir.mktmpdir("helm-package-") do |temp|
  installation = Pathname(temp).join("installed plugin")
  workspace = Pathname(temp).join("consumer workspace")
  installation.mkpath
  workspace.mkpath
  (HelmValidation::COMPONENTS + [".gitattributes"]).each { |component| FileUtils.cp_r(root.join(component), installation) }
  Dir.chdir(workspace) { HelmValidation.validate(installation) }
  HelmValidation.check(workspace.children.empty?, "Package validation wrote to the consumer workspace")

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

puts "Passed relocated-package, missing-resource, path-containment, and real Git-archive checks."
