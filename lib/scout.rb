require 'active_support/all'
require 'curb'
require 'squire'
require 'sidekiq'
require 'scout/version'
require 'scout/downloader'
require 'scout/worker'

module Scout
  include Squire
end
