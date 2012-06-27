# -*- encoding: utf-8 -*-
require File.expand_path('../lib/appshot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Morgan Nelson"]
  gem.email         = ["mnelson@steele-forge.com"]
  gem.description   = %q{AppShot takes an application aware snapshot of your drive volume using pluggable modules representing actions to be taken concerning applications, filesystems, cloud providers, etc.}
  gem.summary       = %q{Appshot takes consistent snapshots of drive volumes.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "appshot"
  gem.require_paths = ["lib"]
  gem.version       = Appshot::VERSION

  gem.add_runtime_dependency "fog", "~> 1.4.0"
  gem.add_runtime_dependency "methadone", "~> 1.2.1"

  gem.add_development_dependency "aruba"
  gem.add_development_dependency "bundler",      "~> 1.0"
  gem.add_development_dependency "fabrication",  "~> 2.0.1"
  gem.add_development_dependency "rake",         "~> 0.9.0"
  gem.add_development_dependency "rake",         "~> 0.9.2"
  gem.add_development_dependency "rdoc"
  gem.add_development_dependency "rspec",        "~> 2.6"
  gem.add_development_dependency "timecop",      "~> 0.3.5"
end
