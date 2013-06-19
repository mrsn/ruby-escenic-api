# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'escenic-api/version'

Gem::Specification.new do |spec|
  spec.name        = 'escenic-api'
  spec.version     = Escenic::API::VERSION
  spec.authors     = ['Todd Edwards']
  spec.email       = %w(automation@mcclatchyinteractive.com)
  spec.description = 'A Ruby client for the Escenic API'
  spec.summary     = 'Provide Ruby applications communication capabilities with the Escenic API'
  spec.homepage    = 'http://www.github.com/toddedw/escenic-api'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'json', '~> 1.7.7'
  spec.add_dependency 'hashie'
  spec.add_dependency 'mime-types'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'geminabox'

end
