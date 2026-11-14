require "pathname"
require "yaml"

# Overview pages (front matter with `detailed`) of the authored guide pairs,
# shared by the guide-pair tests. Generated and third-party trees are skipped.
module GuidePairs
  EXCLUDED_DIRECTORIES = %w[_site .jekyll-cache node_modules].freeze

  def self.overviews(root)
    docs = root.join("docs")
    root.glob("docs/**/*.md").filter_map do |path|
      next if path.relative_path_from(docs).each_filename.any? { |name| EXCLUDED_DIRECTORIES.include?(name) }
      text = path.read
      next unless text.start_with?("---\n")
      frontmatter = text.match(/\A---\n(.*?)\n---\n/m) or raise "Missing front matter: #{path}"
      data = YAML.safe_load(frontmatter[1])
      [path, data] if data && data["detailed"]
    end
  end

  def self.overview_url(root, source, data)
    data["permalink"] || "/#{source.relative_path_from(root).sub_ext('.html')}"
  end
end
