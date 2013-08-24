module Scout
  class Downloader
    include Squire
    include Scout::Logger
    include Scout::Cache

    attr_accessor :adapter, :headers, :cookies, :proxy_url

    def headers
      @headers ||= Hash.new
    end

    def cookies
      @cookies ||= Hash.new
    end

    def add_header(name, value)
      headers[name.to_s.split('_').map(&:capitalize).join('-')] = value
    end

    def add_cookie(name, value)
      cookies[name] = value
    end

    def download(url, options = {})
      return cache.get(url) if cache.enabled? && cache.exists?(url)

      times = options[:times] || 3

      1.upto(times) do |n|
        logger.before "Downloading #{url} (#{n}th try)"

        begin
          response = adapter.get(url) do |http|
            http.headers         = headers
            http.cookies         = cookies.map { |k, v| "#{k}=#{v}" }.join(';') if cookies.any?
            http.follow_location = true
            http.proxy_url       = proxy_url if proxy_url
          end

          logger.raise HTTPError.new "Response code #{response.code}." unless response.code == 200

          cache.store(url, response.body) if cache.enabled?

          logger.after "done (#{response.body.length} bytes)"

          return response
        rescue HTTPError => e
          logger.error e.message
        ensure
          return response if times == n
        end
      end
    end

    def adapter
      @adapter ||= Downloder.config.adapter
    end

    class Error < StandardError; end
    class HTTPError < Downloader::Error; end
  end
end
