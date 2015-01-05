# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticache_snapshot/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticache_snapshot"
  spec.version       = ElasticacheSnapshot::VERSION
  spec.authors       = ["Yohei Kawahara(kappa)"]
  spec.email         = [""]
  spec.summary       = %q{AWS ElastiCache for Redis Snapshot tool}
  spec.description   = %q{AWS ElastiCache for Redis Snapshot tool}
  spec.homepage      = "https://github.com/inokappa/elasticache_snapshot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  #spec.add_development_dependency "bundler", "~> 1.7"
  #spec.add_development_dependency "rake", "~> 10.0"
  #spec.add_development_dependency "rspec"

  spec.add_dependency "thor"
  spec.add_dependency "io-console"
  spec.add_dependency "aws-sdk"
end
