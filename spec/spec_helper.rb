require 'rubygems'
require 'bundler/setup'

require 'scout'

RSpec.configure do |config|
end

Scout.config do |config|
  config.logger.verbose = false
end
