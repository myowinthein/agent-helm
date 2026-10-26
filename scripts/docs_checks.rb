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
end
