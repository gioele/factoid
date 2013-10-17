# This is free software released into the public domain (CC0 license).


lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'factoid/version'

Gem::Specification.new do |spec|
	spec.name          = "factoid"
	spec.version       = Factoid::VERSION
	spec.authors       = ["Gioele Barabucci"]
	spec.email         = ["gioele@svario.it"]
	spec.summary       = "factoid is a Ruby library to manipulate factoids " +
	                     "entitoids inside Ruby applications without " +
	                     "touching the their XML representations."
	spec.homepage      = 'http://svario.it/factoid/ruby'
	spec.license       = 'CC0'

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ['lib']

	spec.add_dependency 'nokogiri'
	spec.add_dependency 'addressable'

	spec.add_development_dependency 'bundler', '~> 1.3'
	spec.add_development_dependency 'rake'
	spec.add_development_dependency 'rspec'
end
