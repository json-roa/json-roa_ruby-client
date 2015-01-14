# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_roa/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'json_roa-client'
  spec.version       = JSON_ROA::Client::VERSION
  spec.authors       = ['Thomas Schank']
  spec.email         = ['DrTom@schank.ch']
  spec.summary       = 'The Ruby JSON-ROA Client Reference Implementation'
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'cider_ci-support', '= 1.1.0.pre.beta.3'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'addressable', '~> 2'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '~> 0.9'

end
