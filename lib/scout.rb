require 'active_support/concern'
require 'redis'
require 'colored'
require 'curb'
require 'squire'
require 'scout/version'
require 'scout/cache/redis_store'
require 'scout/cache'
require 'scout/downloader/curb_adapter'
require 'scout/downloader'

module Scout
  include Squire
end

Scout.config do |config|
  config.cache do |cache|
    cache.enabled = false
    cache.adapter = Scout::Cache::RedisStore.new
  end

  config.downloader do |downloader|
    downloader.adapter = Scout::Downloader::CurbAdapter
  end
end
