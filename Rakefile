require "rake"
require_relative "scripts/docs_checks"

desc "Validate shared workflows and exported package contents"
task :plugin_test do
  ruby "scripts/test_plugin.rb"
end

desc "Build the documentation site and check internal links, images, and scripts"
task :docs_test do
  require "html-proofer"
  require "yaml"
  ruby Gem.bin_path("jekyll", "jekyll"), "build"
  config = YAML.safe_load_file("_config.yml")
  HTMLProofer.check_directory("./_site", HelmDocs.options(config)).run
  HelmDocs.check_setup("./_site", config)
  puts "Passed setup fallback destinations and panel markup contracts; browser checks remain separate."
end

desc "Test pure normalize checks and semantic coverage selection with synthetic inputs"
task :normalize_test do
  sh "python3", "-I", "-B", "scripts/test_normalize.py"
end

desc "Test private normalize-to-ship locator I/O in disposable clones"
task :normalize_handoff_test do
  sh "python3", "-I", "-B", "scripts/test_normalize_handoff.py"
end

desc "Test read-only ledger isolation, validation and retrieval with synthetic consumers"
task :ledger_test do
  sh "python3", "-I", "-B", "scripts/test_ledger.py"
end

desc "Test smoke fixture preconditions and preservation assertions without models"
task :smoke_support_test do
  ruby "scripts/test_smoke_support.rb"
end

desc "Test complete model traces and acceptance oracles without calling models"
task :acceptance_support_test do
  ruby "scripts/test_acceptance_support.rb"
  ruby "scripts/test_git_acceptance.rb"
  ruby "scripts/test_acceptance_oracles.rb"
end

desc "Test offline validation of absolute own-site links and images"
task :docs_links_test do
  ruby "scripts/test_docs_links.rb"
end

desc "Check plugin packaging, helpers, smoke assertions and documentation"
task test: %i[plugin_test normalize_test normalize_handoff_test ledger_test smoke_support_test acceptance_support_test docs_links_test docs_test]
task default: :test
