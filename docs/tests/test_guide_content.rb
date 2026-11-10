require "jekyll"
require "nokogiri"
require "pathname"
require "tmpdir"
require_relative "../_plugins/guide_content"

def check(condition, message)
  raise message unless condition
end

Dir.mktmpdir("helm-guide-content-") do |temporary|
  root = Pathname(temporary)
  root.join("docs").mkpath()
  root.join("guides").mkpath
  original = <<~MARKDOWN
    # example

    A complete introduction.

    ## Review

    Preserve the approval boundary. See [shared policy](../prompts/shared/policy.md#approval),
    [the other guide](other.md#result), [this section](#review) and [the standard](https://example.invalid/spec).

    ```markdown
    [Literal example](../unchanged.md)
    ```

    ## Result

    Report verified results and pending work.
  MARKDOWN
  root.join("guides/example.md").write(original)
  root.join("guides/no-intro.md").write("# no-intro\n\n## Review\n\nDo the approved work.\n\n## Finish\n\nReport the result.\n")
  site = Jekyll::Site.new(Jekyll.configuration("source" => root.join("docs").to_s, "quiet" => true, "plugins_dir" => [], "baseurl" => "/helm"))
  page = Struct.new(:data, :url).new({ "guide_source" => "guides/other.md", "overview" => "/overview.html" }, "/other/detailed.html")
  site.pages << page

  intro, body = HelmGuideContent.parts(site, "guides/example.md")
  check(intro.strip == "A complete introduction.", "Introduction was lost or includes source heading")
  check(body.start_with?("## Review"), "Procedure was omitted or reordered")
  empty_intro, complete_body = HelmGuideContent.parts(site, "guides/no-intro.md")
  check(empty_intro.empty? && complete_body.include?("Do the approved work.") && complete_body.include?("Report the result."),
        "Heading-first source lost or separated part of its body")

  html = HelmGuideContent.render(site, "guides/example.md", body, contents: true)
  document = Nokogiri::HTML.fragment(html)
  links = document.css("a").to_h { |link| [link.text, link["href"]] }
  check(links["shared policy"] == "#{HelmGuideContent::SOURCE_URL}prompts/shared/policy.md#approval", "Supporting procedure points at the wrong web path")
  check(links["the other guide"] == "/helm/other/detailed.html#result", "Canonical guide failed to use its detailed page")
  check(links["this section"] == "#review", "Same-page fragment changed")
  check(links["the standard"] == "https://example.invalid/spec", "External source changed")
  check(document.at_css("#markdown-toc a[href='#result']"), "Generated contents lack section targets")
  check(document.at_css("code").text.include?("[Literal example](../unchanged.md)"), "Code example was treated as navigation")
  check(document.css("h1").empty? && document.css("h2").length == 2, "Source title or procedure headings were duplicated/lost")
  check(root.join("guides/example.md").read == original, "Rendering changed canonical instructions")

  Dir.mktmpdir("helm-guide-outside-") do |elsewhere|
    outside = Pathname(elsewhere).join("outside.md")
    outside.write("Do not expose this file.")
    root.join("guides/escape.md").make_symlink(outside)
    %w[.helm/normalize-log.json ../outside.md guides/missing.md guides/escape.md].each do |path|
      begin
        HelmGuideContent.read_source(site, path)
        raise "Accepted unavailable or unauthorized source: #{path}"
      rescue ArgumentError
        # Expected: reject before rendering any source outside the declared owners.
      end
    end
  end

  site.pages << page.dup
  begin
    HelmGuideContent.destination(site, "guides/example.md", "other.md")
    raise "Accepted two detailed pages for the same canonical source"
  rescue ArgumentError => error
    raise unless error.message.include?("Multiple detailed guides")
  end
end

puts "Passed canonical guide rendering, section links, literal code, unchanged-source and source-boundary checks."
