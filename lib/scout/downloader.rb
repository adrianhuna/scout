require 'open-uri'
require 'curb'

module Scout
  class Downloader
    def self.download(url, options = {})
      url = URI.encode(url)

      times = options[:times] || 3

      1.upto(times) do |n|
        sleep options[:timeout] || 0

        begin
          response = Curl.get(url) do |http|
            http.headers         = format_headers options[:headers] if options[:headers]
            http.cookies         = format_cookies options[:cookies] if options[:cookies]
            http.follow_location = true
            http.proxy_url       = options[:proxy_url] if options[:proxy_url]
          end

          unless response.response_code == 200
            raise HTTPError.new "Response code #{response.response_code}."
          end

          return response.body_str
        rescue HTTPError => e
          puts e.message

          raise e if times == n
        end
      end
    end

    private

    def self.format_headers(headers)
      headers.inject({}) do |result, (name, value)|
        result[name.to_s.split('_').map(&:capitalize).join('-')] = value

        result
      end
    end

    def self.format_cookies(cookies)
      cookies.map { |k, v| "#{k}=#{v}" }.join(';')
    end

    class HTTPError < StandardError
    end
  end
end
