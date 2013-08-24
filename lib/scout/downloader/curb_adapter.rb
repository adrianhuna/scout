module Scout
  class Downloader
    class CurbAdapter
      def self.get(url, &block)
        response = Curl.get(url) do |http|
          block.call(http)
        end

        CurbResponse.new(response)
      end

      class CurbResponse
        attr_reader :response

        def initialize(response)
          @response = response
        end

        def code
          response.response_code
        end

        def body
          response.body_str
        end

        def url
          response.last_effective_url
        end
      end
    end
  end
end
