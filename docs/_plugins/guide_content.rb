require "kramdown"
require "kramdown-parser-gfm"
require "pathname"
require "uri"

# The site renders the same plain Markdown that skills load. Diagrams and view
# navigation belong to the page wrapper, keeping them out of agent context.
module HelmGuideContent
  SOURCE_URL = "https://github.com/myowinthein/agent-helm/blob/main/".freeze
  SOURCE_PATH = %r{\A(?:guides/[a-z-]+|rules/[a-z-]+|prompts/archive/step[1-5]-[a-z-]+)\.md\z}
  module_function

  def read_source(site, source)
    raise ArgumentError, "Unknown guide source: #{source}" unless source.is_a?(String) && SOURCE_PATH.match?(source)

    root = Pathname(site.source).parent.realpath
    file = root.join(source)
    unless file.file? && file.realpath.to_s.start_with?("#{root}/")
      raise ArgumentError, "Guide source is missing or outside the project: #{source}"
    end
    file.read(encoding: "UTF-8").sub(/\A# [^\n]+\n+/, "")
  end

  def parts(site, source)
    markdown = read_source(site, source)
    return ["", markdown] if markdown.start_with?("## ")

    markdown.split(/(?=^## )/, 2)
  end

  def destination(site, source, href)
    return href if href.start_with?("#", "/") || URI.parse(href).scheme

    uri = URI.parse(href)
    target = Pathname(source).parent.join(URI::DEFAULT_PARSER.unescape(uri.path)).cleanpath.to_s
    raise ArgumentError, "Guide reference escapes the project: #{href}" if target.start_with?("../")

    pages = site.pages.select { |candidate| candidate.data["guide_source"] == target && candidate.data["overview"] }
    raise ArgumentError, "Multiple detailed guides own #{target}" if pages.length > 1

    page = pages.first
    path = page ? "#{site.baseurl}#{page.url}" : "#{SOURCE_URL}#{target}"
    path += "?#{uri.query}" if uri.query
    path += "##{uri.fragment}" if uri.fragment
    path
  end

  def render(site, source, markdown, contents: false, trim_leading_dividers: false)
    if contents
      markdown = "**In this guide**\n\n* Contents\n{:toc}\n\n#{markdown}"
    end
    document = Kramdown::Document.new(markdown, input: "GFM", syntax_highlighter: "rouge", toc_levels: "2")
    if trim_leading_dividers
      document.root.children.shift while %i[hr blank].include?(document.root.children.first&.type)
    end
    walk = lambda do |element|
      if element.type == :a && element.attr["href"]
        element.attr["href"] = destination(site, source, element.attr["href"])
      end
      element.children.each { |child| walk.call(child) }
    end
    walk.call(document.root)
    document.to_html
  end
end

module HelmGuideFilters
  def guide_intro(source)
    site = @context.registers[:site]
    intro, = HelmGuideContent.parts(site, source)
    HelmGuideContent.render(site, source, intro.to_s, trim_leading_dividers: true)
  end

  def guide_body(source)
    site = @context.registers[:site]
    _, body = HelmGuideContent.parts(site, source)
    HelmGuideContent.render(site, source, body.to_s, contents: true)
  end
end

Liquid::Template.register_filter(HelmGuideFilters)
