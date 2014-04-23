# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wcc/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "wcc-auth"
  spec.version       = WCC::Auth::VERSION
  spec.authors       = ["Travis Petticrew"]
  spec.email         = ["tpetticrew@watermark.org"]
  spec.description   = %q{Simple gem for setting up authentication to Watermark}
  spec.summary       = %q{Simple gem for setting up authentication to Watermark}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cancan", "~> 1.6"
  spec.add_dependency "devise", "~> 3.1"
  spec.add_dependency "omniauth", "~> 1.1"
  spec.add_dependency "omniauth-oauth2", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
