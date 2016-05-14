# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'procps/version'

Gem::Specification.new do |spec|
  spec.name          = "procps-rb"
  spec.version       = Procps::VERSION
  spec.authors       = ["Anton Semenov"]
  spec.email         = ["anton.estum@gmail.com"]

  spec.summary       = %q{Ruby procps wrapper.}
  spec.description   = %q{Ruby procps wrapper.}
  spec.homepage      = "https://github.com/estum/procps-rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
