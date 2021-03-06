# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "starapi/version"

Gem::Specification.new do |gem|
  gem.authors       = ["Filipe Chagas"]
  gem.email         = ["filipe@ochagas.com"]
  gem.license = "MIT"
  gem.description   = %q{Gem created in order to consume READi System Webservices}
  gem.summary       = %q{Gem created in order to consume READi System Webservices}
  gem.homepage      = "http://github.com/Quezmedia/quez_starapi"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "starapi"
  gem.require_paths = ["lib", "lib/soap_service_facade", "lib/soap_service_target"]
  gem.version       = Starapi::VERSION

  gem.add_runtime_dependency 'typhoeus'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'logging'
  gem.add_dependency("railties", "~> 3.1")

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

end
