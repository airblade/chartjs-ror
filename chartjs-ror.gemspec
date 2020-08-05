# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chartjs/version'

Gem::Specification.new do |gem|
  gem.name          = "chartjs-ror"
  gem.version       = Chartjs::VERSION
  gem.authors       = ["Andy Stewart"]
  gem.email         = ["boss@airbladesoftware.com"]
  gem.description   = 'Simplifies using Chart.js in Rails'
  gem.summary       = 'Simplifies using Chart.js in Rails'
  gem.homepage      = 'https://github.com/airblade/chartjs-ror'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rails', '>= 3.1'
  gem.add_development_dependency 'rake'
end
