# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynameister/version'

Gem::Specification.new do |spec|
  spec.name          = "dynameister"
  spec.version       = Dynameister::VERSION
  spec.authors       = ["Oliver Grimm", "Sebastian Oelke", "Nicola Sheldrick"]
  spec.email         = ["ogrimm@babbel.com", "soelke@babbel.com", "nsheldrick@babbel.com"]
  spec.summary       = "A Ruby convenience wrapper for Amazon's DynamoDB."
  spec.description   = "Dynameister is an Object Document Mapper (ODM) for Amazon's
                        DynamoDB. It provides a convenient interface for CRUD operations
                        of your models. Besides that, global and local secondary
                        indexes are supported."
  spec.homepage      = "https://github.com/lessonnine/dynameister.gem"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk",                    "~> 2.0"
  spec.add_dependency "dotenv"
  spec.add_dependency "activesupport",              "~> 4.2"

  spec.add_development_dependency "bundler",        "~> 1.7"
  spec.add_development_dependency "rake",           "~> 10.0"
  spec.add_development_dependency "rspec",          "~> 3.3"
  spec.add_development_dependency "rspec-its",      "~> 1.2"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rubocop"
end
