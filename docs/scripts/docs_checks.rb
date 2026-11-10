require "uri"

module HelmDocs
  module_function

  def url_swaps(config)
    baseurl = config.fetch("baseurl", "").to_s.sub(%r{/+\z}, "")
    raise ArgumentError, "Site baseurl must be empty or start with /" unless baseurl.empty? || baseurl.start_with?("/")
    swaps = {}
    # HTMLProofer applies these sequentially. Strip the relative base first so
    # the absolute mapping cannot cause a second strip of a real nested path.
    swaps[/\A#{Regexp.escape(baseurl)}(?:\/|(?=[?#]|\z))/] = "/" unless baseurl.empty?
    origin = config.fetch("url", "").to_s.sub(%r{/+\z}, "")
    unless origin.empty?
      uri = URI.parse(origin)
      unless %w[http https].include?(uri.scheme) && uri.host && uri.userinfo.nil? &&
             uri.path.to_s.empty? && uri.query.nil? && uri.fragment.nil?
        raise ArgumentError, "Site url must be an HTTP(S) origin without credentials"
      end
      swaps[/\A(?i:#{Regexp.escape(origin)})#{Regexp.escape(baseurl)}(?:\/|(?=[?#]|\z))/] = "/"
    end
    swaps
  rescue URI::InvalidURIError
    raise ArgumentError, "Site url must be a valid HTTP(S) origin", cause: nil
  end

  def options(config)
    { disable_external: true, swap_urls: url_swaps(config), checks: %w[Html Images Scripts Links] }
  end

  # Check built fallback markup. Visibility, keyboard, redirects and print need a browser.
  def check_setup(directory, config)
    require "nokogiri"
    require "pathname"
    root = Pathname(directory)
    baseurl = config.fetch("baseurl", "").to_s.sub(%r{/+\z}, "")
    %w[claude codex].each do |platform|
      path = root.join("docs/setup/#{platform}.html")
      raise "Setup contract: missing #{platform} page" unless path.file?
      page = Nokogiri::HTML(path.read)
      %w[desktop terminal].each do |method|
        panel = page.at_css("[data-setup-panel][id='#{method}']")
        unless panel && !panel.key?("hidden") && !panel["style"].to_s.match?(/display\s*:\s*none|visibility\s*:\s*hidden/i)
          raise "Setup contract: #{platform}/#{method} is unavailable without JavaScript"
        end
        %w[install update uninstall].each do |section|
          unless panel.at_css("[id='#{method}-#{section}']")
            raise "Setup contract: missing #{platform}/#{method} #{section} anchor"
          end
        end
        legacy_path = root.join("docs/setup/#{platform}-#{method}.html")
        raise "Setup contract: missing #{platform}-#{method} redirect" unless legacy_path.file?
        legacy = Nokogiri::HTML(legacy_path.read)
        link = legacy.at_css("a#setup-destination")
        expected = "#{baseurl}/docs/setup/#{platform}.html##{method}"
        unless link && link["href"] == expected
          raise "Setup contract: incorrect #{platform}-#{method} fallback destination"
        end
      end
    end
  end
end
