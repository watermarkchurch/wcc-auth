# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcc/auth/version'

Gem::Specification.new do |spec|
  spec.name          = 'wcc-auth'
  spec.version       = WCC::Auth::VERSION
  spec.authors       = ['Watermark Dev']
  spec.email         = ['dev@watermark.org']
  spec.description   = 'Authentication / Authorization library for Watermark apps'
  spec.summary       = File.readlines('README.md').join
  spec.homepage      = 'https://github.com/watermarkchurch/wcc-auth'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.3'

  spec.add_dependency 'cancancan', '~> 1.17.0'
  spec.add_dependency 'devise', '~> 4.7.0'
  spec.add_dependency 'omniauth', '~> 1.9.0'
  spec.add_dependency 'omniauth-oauth2', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.6.0'
end
