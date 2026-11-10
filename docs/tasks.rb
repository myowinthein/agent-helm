require_relative "scripts/docs_checks"

desc "Build the documentation site and check internal links, images, and scripts"
task :docs_test do
  require "html-proofer"
  require "yaml"
  Dir.chdir("docs") { ruby Gem.bin_path("jekyll", "jekyll"), "build" }
  config = YAML.safe_load_file("docs/_config.yml")
  HTMLProofer.check_directory("./docs/_site", HelmDocs.options(config)).run
  HelmDocs.check_setup("./docs/_site", config)
  puts "Passed setup fallback destinations and panel markup contracts; browser checks remain separate."
end

desc "Test offline documentation links and content-based asset versions"
task :docs_links_test do
  ruby "docs/tests/test_repository_content.rb"
  ruby "docs/tests/test_docs_links.rb"
  ruby "docs/tests/test_docs_workflow.rb"
  ruby "docs/tests/test_asset_digest.rb"
  ruby "docs/tests/test_guide_content.rb"
end
