require "rake"

desc "Validate shared workflows and exported package contents"
task :plugin_test do
  ruby "scripts/test_plugin.rb"
end

desc "Build the documentation site and check internal links, images, and scripts"
task :docs_test do
  require "html-proofer"
  require "yaml"
  ruby Gem.bin_path("jekyll", "jekyll"), "build"
  baseurl = YAML.safe_load_file("_config.yml").fetch("baseurl", "").to_s
  swaps = baseurl.empty? ? {} : { /\A#{Regexp.escape(baseurl)}\// => "/" }
  HTMLProofer.check_directory("./_site", disable_external: true, swap_urls: swaps, checks: %w[Html Images Scripts Links]).run
end

desc "Check plugin packaging and documentation"
task test: %i[plugin_test docs_test]
task default: :test
