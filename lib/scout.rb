require 'active_support/concern'
require 'redis'
require 'colored'
require 'curb'
require 'squire'
require 'scout/version'
require 'scout/logger/std'
require 'scout/logger'
require 'scout/cache/redis_store'
require 'scout/cache'
require 'scout/downloader/curb_adapter'
require 'scout/downloader'

module Scout
  include Squire
end

Scout.config do |config|
  config.logger     = Scout::Logger.config
  config.downloader = Scout::Downloader.config
  config.cache      = Scout::Cache.config

  config.cache do |cache|
    cache.adapter = Scout::Cache::RedisStore.new
  end

  config.downloader do |downloader|
    downloader.adapter = Scout::Downloader::CurbAdapter
  end

  config.logger do |logger|
    logger.output  = Scout::Logger::Std
    logger.verbose = true
  end
end
