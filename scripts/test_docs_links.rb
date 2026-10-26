# Exercise the actual HTMLProofer checker on synthetic sites; never fetch URLs.
require "html-proofer"
require "pathname"
require "stringio"
require "tmpdir"
require_relative "docs_checks"

CONFIG = { "url" => "https://docs.example.invalid", "baseurl" => "/agent-helm" }.freeze
PREFIX = "https://docs.example.invalid/agent-helm"

def verify_setup_contracts
  files = {}
  %w[claude codex].each do |platform|
    files["#{platform}.html"] = %w[desktop terminal].map do |method|
      headings = %w[install update uninstall].map { |section| %(<h2 id="#{method}-#{section}">#{section}</h2>) }.join
      %(<section id="#{method}" data-setup-panel>#{headings}</section>)
    end.join
    %w[desktop terminal].each do |method|
      files["#{platform}-#{method}.html"] = %(<a id="setup-destination" href="/agent-helm/docs/setup/#{platform}.html##{method}">Setup</a>)
    end
  end
  mutations = { "valid setup fallbacks" => ->(_) {} }
  %w[claude codex].each do |platform|
    %w[desktop terminal].each do |method|
      mutations["wrong #{platform}-#{method} destination"] = ->(copy) { copy["#{platform}-#{method}.html"].sub!("##{method}", "#wrong") }
    end
  end
  mutations.merge!(
    "missing legacy page" => ->(copy) { copy.delete("claude-desktop.html") },
    "missing fallback link" => ->(copy) { copy["codex-terminal.html"] = "<p>Moved</p>" },
    "hidden no-JavaScript panel" => ->(copy) { copy["claude.html"].sub!("data-setup-panel", "data-setup-panel hidden") },
    "inline-hidden no-JavaScript panel" => ->(copy) { copy["codex.html"].sub!("data-setup-panel", 'data-setup-panel style="display:none"') },
    "missing section anchor" => ->(copy) { copy["codex.html"].sub!("terminal-update", "removed") }
  )
  mutations.each do |name, mutate|
    Dir.mktmpdir("helm-setup-html-") do |temporary|
      copy = files.transform_values(&:dup)
      mutate.call(copy)
      copy.each do |filename, body|
        path = Pathname(temporary).join("docs/setup", filename)
        path.parent.mkpath
        path.write(body)
      end
      error = nil
      begin
        HelmDocs.check_setup(temporary, CONFIG)
      rescue RuntimeError => caught
        raise unless caught.message.start_with?("Setup contract:")
        error = caught
      end
      raise "#{name}: incorrect setup checker outcome" unless error.nil? == (name == "valid setup fallbacks")
      puts "PASS setup HTML: #{name}"
    end
  end
end

verify_setup_contracts

def html(body)
  "<!doctype html><html><head><title>Synthetic site</title></head><body>#{body}</body></html>"
end

def verify_site(name, body, passes:, config: CONFIG, external: [])
  Dir.mktmpdir("helm-docs-links-") do |temporary|
    root = Pathname(temporary)
    { "index.html" => html('<h1 id="home">Home</h1>'),
      "guide/index.html" => html('<h2 id="install">Install</h2>'),
      "agent-helm/nested/index.html" => html('<h2 id="retained">Nested path</h2>'),
      "assets/icon.svg" => '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48"></svg>',
      "probe.html" => html(body) }.each do |name, contents|
      path = root.join(name)
      path.parent.mkpath
      path.write(contents)
    end
    runner = HTMLProofer.check_directory(root.to_s, HelmDocs.options(config).merge(log_level: :fatal))
    runner.define_singleton_method(:validate_external_urls) { raise "External validation must stay disabled" }
    output, errors = $stdout, $stderr
    begin
      $stdout = StringIO.new
      $stderr = StringIO.new
      success = true
      begin
        runner.run
      rescue SystemExit => error
        raise unless error.status == 1 && !runner.failed_checks.empty?
        success = false
      end
    ensure
      $stdout, $stderr = output, errors
    end
    expected = passes.respond_to?(:call) ? passes.call(root) : passes
    raise "#{name}: incorrect HTMLProofer outcome" unless success == expected
    external.each do |url|
      raise "#{name}: URL escaped its external boundary" unless runner.external_urls.key?(url)
    end
    puts "PASS docs links: #{name}"
  end
end

cases = [
  ["own absolute file and fragment", %(<a href="#{PREFIX}/guide/#install">Guide</a>), true],
  ["own absolute query and fragment", %(<a href="#{PREFIX}/guide/?view=full#install">Guide</a>), true],
  ["own missing absolute file", %(<a href="#{PREFIX}/missing.html">Missing</a>), false],
  ["own missing absolute fragment", %(<a href="#{PREFIX}/guide/#absent">Missing</a>), false],
  ["own absolute image", %(<img src="#{PREFIX}/assets/icon.svg" alt="Fixture">), true],
  ["own missing absolute image", %(<img src="#{PREFIX}/assets/missing.svg" alt="Missing">), false],
  ["bare own root", %(<a href="#{PREFIX}">Root</a>), true],
  ["slashed own root", %(<a href="#{PREFIX}/">Root</a>), true],
  ["bare own root with fragment", %(<a href="#{PREFIX}#home">Root</a>), true],
  ["bare own root with query", %(<a href="#{PREFIX}?view=full#home">Root</a>), true],
  ["bare own root with missing fragment", %(<a href="#{PREFIX}#absent">Root</a>), false],
  ["relative links keep working", '<a href="guide/#install">Guide</a>', true],
  ["baseurl-relative links keep working", '<a href="/agent-helm/guide/#install">Guide</a>', true],
  ["baseurl-relative missing target", '<a href="/agent-helm/missing.html">Missing</a>', false],
  ["repeated baseurl is stripped only once", %(<a href="#{PREFIX}/agent-helm/nested/#retained">Nested</a>), true],
  ["origin casing preserves path casing", '<a href="https://DOCS.EXAMPLE.INVALID/agent-helm/guide/#install">Guide</a>', true],
  # Local checks inherit the filesystem's case behavior: this path is missing
  # on a case-sensitive filesystem, while a case-insensitive Mac can resolve it.
  ["path lookup honors local filesystem casing", %(<a href="#{PREFIX}/GUIDE/#install">Path</a>), ->(root) { root.join("GUIDE/index.html").file? }]
]
cases.each { |name, body, passes| verify_site(name, body, passes: passes) }

external_urls = ["https://elsewhere.example.invalid/missing.html",
                 "https://docs.example.invalid.evil.invalid/agent-helm/missing.html",
                 "https://docs.example.invalid/agent-helm-other/missing.html",
                 "https://docs.example.invalid/AGENT-HELM/missing.html"]
external_urls.each do |url|
  verify_site("external/lookalike remains unfetched: #{url}", %(<a href="#{url}">External</a>), passes: true, external: [url])
end
external_image = "https://images.example.invalid/missing.svg"
verify_site("external image stays unfetched", %(<img src="#{external_image}" alt="External">), passes: true, external: [external_image])
verify_site("empty baseurl supports own absolute URLs", '<a href="https://docs.example.invalid/guide/#install">Guide</a>',
            passes: true, config: CONFIG.merge("baseurl" => ""))
verify_site("trailing config slashes preserve root links", %(<a href="#{PREFIX}/guide/#install">Guide</a>),
            passes: true, config: CONFIG.merge("url" => CONFIG.fetch("url") + "/", "baseurl" => "/agent-helm/"))
puts "Passed #{cases.length + external_urls.length + 3} offline docs-link scenarios; external validation was forbidden."
