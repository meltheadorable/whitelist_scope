# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whitelist_scope/version'

Gem::Specification.new do |spec|
  spec.name          = "whitelist_scope"
  spec.version       = WhitelistScope::VERSION
  spec.authors       = ["Melody"]
  spec.email         = ["meltheadorable@gmail.com"]

  spec.homepage    = "https://github.com/meltheadorable/sortify"
  spec.summary     = "whitelist_scope provides a safe way to register and call scopes inside rails apps"
  spec.description = "whitelist_scope acts as a wrapper around ActiveRecord scopes, providing a tiny bit of extra functionality to keep track of whitelisted scopes and call them from user input."
  spec.license     = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.2.0"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fuubar"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "appraisal"
end
