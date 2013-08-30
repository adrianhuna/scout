module Scout
  class Downloader
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
        begin
          response = adapter.get(url) do |http|
            http.headers         = headers
            http.cookies         = cookies.map { |k, v| "#{k}=#{v}" }.join(';') if cookies.any?
            http.follow_location = true
            http.proxy_url       = proxy_url if proxy_url
          end

          raise HTTPError.new "Response code #{response.code}." unless response.code == 200

          cache.store(url, response.body) if cache.enabled?

          return response
        rescue HTTPError => e
          puts e.message
        ensure
          return response if times == n
        end
      end
    end

    def adapter
      @adapter ||= Scout.config.downloader.adapter
    end

    class Error < StandardError; end
    class HTTPError < Downloader::Error; end
  end
end
