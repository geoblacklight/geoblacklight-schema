# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'geoblacklight-schema'
  spec.version       = '0.0.1'
  spec.authors       = ['Darren Hardy']
  spec.email         = ['drh@stanford.edu']
  spec.summary       = 'Schema Tools for GeoBlacklight'
  spec.homepage      = 'http://github.com/geoblacklight/geoblacklight-schema'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split(%Q{\x0})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_dependency 'saxon-xslt', '~> 0.2.0.1' # Requires JRuby

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.3.2'
end
