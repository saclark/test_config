# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'test_config'
  spec.version       = TestConfig::VERSION
  spec.authors       = ['Scott Clark']
  spec.email         = ['sclarkdev@gmail.com']
  spec.summary       = 'Flexible cucumber test configuration.'
  spec.description   = 'A flexible means of configuration for cucumber tests.'
  spec.homepage      = 'https://github.com/saclark/test_config'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'coveralls'
end
