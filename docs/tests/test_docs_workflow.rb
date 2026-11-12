# Keep the Pages workflow aligned with the docs site layout without running GitHub Actions.
require "pathname"
require "yaml"

root = Pathname(__dir__).parent.parent
workflow = YAML.safe_load_file(root.join(".github/workflows/docs.yml"))
config = YAML.safe_load_file(root.join("docs/_config.yml"))

def verify(workflow, config)
  steps = workflow.fetch("jobs").fetch("build").fetch("steps")
  build = steps.find { |step| step["run"] == "bundle exec jekyll build" }
  upload = steps.find { |step| step["uses"].to_s.start_with?("actions/upload-pages-artifact@") }
  setup = steps.find { |step| step["uses"].to_s.start_with?("ruby/setup-ruby@") }
  theme = steps.find { |step| step["run"].to_s.include?("_config.yml") }
  raise "Docs workflow lost a build, upload, Ruby setup or theme step" unless build && upload && setup && theme
  node = steps.find { |step| step["uses"].to_s.start_with?("actions/setup-node@") }
  install = steps.find { |step| step["run"].to_s.start_with?("npm ci ") }
  browser = steps.find { |step| step["run"].to_s.include?("node tests/browser_frontend.mjs") }
  raise "Missing diagram toolchain or browser checks" unless node && install && browser
  raise "Wrong Node dependency cache" unless node.dig("with", "cache-dependency-path") == "docs/package-lock.json"
  raise "Install must use docs dependencies without lifecycle scripts" unless install["working-directory"] == "docs" && install["run"].include?("--ignore-scripts")
  raise "Browser checks must run in docs after building" unless browser["working-directory"] == "docs" && steps.index(browser) > steps.index(build)
  raise "Node tools must be ready before the build" unless steps.index(node) < steps.index(install) && steps.index(install) < steps.index(build)
  raise "Jekyll must build from the docs directory" unless build["working-directory"] == "docs"
  raise "Theme resolution must edit docs/_config.yml" unless theme["working-directory"] == "docs"
  raise "Bundler must cache the docs Gemfile" unless setup.dig("with", "working-directory") == "docs"
  raise "Jekyll source must stay in the docs directory" unless Pathname("docs").join(config.fetch("source", ".")).cleanpath.to_s == "docs"
  raise "Pages must upload the directory Jekyll writes" unless upload.dig("with", "path") == "docs/#{config.fetch('destination')}"
end

verify(workflow, config)

mutations = {
  "missing Node setup" => ->(w, _) { w["jobs"]["build"]["steps"].reject! { |s| s["uses"].to_s.start_with?("actions/setup-node@") } },
  "wrong Node cache" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["uses"].to_s.start_with?("actions/setup-node@") }["with"]["cache-dependency-path"] = "package-lock.json" },
  "missing diagram install" => ->(w, _) { w["jobs"]["build"]["steps"].reject! { |s| s["run"].to_s.start_with?("npm ci ") } },
  "enabled install scripts" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["run"].to_s.start_with?("npm ci ") }["run"] = "npm ci" },
  "wrong browser directory" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["run"].to_s.include?("node tests/browser_frontend.mjs") }["working-directory"] = "." },
  "wrong build directory" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["run"] == "bundle exec jekyll build" }.delete("working-directory") },
  "wrong theme directory" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["run"].to_s.include?("_config.yml") }["working-directory"] = "." },
  "wrong bundler directory" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["uses"].to_s.start_with?("ruby/setup-ruby@") }["with"].delete("working-directory") },
  "wrong upload path" => ->(w, _) { w["jobs"]["build"]["steps"].find { |s| s["uses"].to_s.start_with?("actions/upload-pages-artifact@") }["with"]["path"] = "_site" },
  "moved destination" => ->(_, c) { c["destination"] = "public" },
  "moved source" => ->(_, c) { c["source"] = ".." }
}
mutations.each do |name, mutate|
  changed = [Marshal.load(Marshal.dump(workflow)), Marshal.load(Marshal.dump(config))]
  mutate.call(*changed)
  begin
    verify(*changed)
  rescue RuntimeError
    next
  end
  raise "Accepted #{name}"
end

puts "Passed docs workflow build directory, bundler cache, theme edit and upload path checks."
