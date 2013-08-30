module Scout
  module Cache
    attr_accessor :cache

    def cache
      @cache ||= Scout.config.cache.adapter
    end
  end
end
