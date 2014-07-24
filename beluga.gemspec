# -*- encoding: utf-8 -*-
require File.expand_path('../lib/beluga/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Johnneylee Jack Rollins", "Emily Jane Dobervich"]
  gem.email         = ["beluga-gem@narwhunderful.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  gem.homepage      = "http://labs.narwhunderful.com/beluga"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "beluga"
  gem.require_paths = ["lib"]
  gem.version       = Beluga::VERSION

  gem.add_development_dependency 'rake'
end
