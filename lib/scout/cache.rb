module Scout
  module Cache
    include Squire

    attr_accessor :cache

    def cache
      @cache ||= Cache.config.adapter
    end
  end
end
