# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scout/version'

Gem::Specification.new do |gem|
  gem.name          = 'scout'
  gem.version       = Scout::VERSION
  gem.authors       = ['Samuel Molnar']
  gem.email         = ['molnar.samuel@gmail.com']
  gem.description   = %q{Your scout knife for exploring web.}
  gem.summary       = %q{Your scout knife for exploring web.}
  gem.homepage      = 'https://github.com/smolnar/scout'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '>= 4.0.0'
  gem.add_dependency 'curb', '~> 0.8.4'
  gem.add_dependency 'squire', '>= 1.2.1'
  gem.add_dependency 'sidekiq', '~> 2.15.2'

  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'fuubar'
  gem.add_development_dependency 'pry'
end
