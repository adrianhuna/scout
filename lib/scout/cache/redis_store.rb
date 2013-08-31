module Scout
  module Cache
    class RedisStore
      attr_reader :enabled, :redis

      def initialize
        @enabled = Scout.config.cache.enabled
      end

      def enable=(value)
        @enabled = value
      end

      def enable
        @enabled = true
      end

      def disable
        @enabled = false
      end

      alias :enabled? :enabled

      def get(key)
        redis.get("cache_#{key}")
      end

      def store(key, value)
        redis.set("cache_#{key}", value)
      end

      def exists(key)
        redis.exists(key)
      end

      def flush
        redis.keys('cache_*') { |k| redis.del(k) }
      end

      def all(prefix = nil)
        redis.keys("cache_#{prefix}*").each { |key| yield redis.get(key) }
      end

      def redis
        @redis ||= Redis.new
      end

      alias :exists? :exists
    end
  end
end
