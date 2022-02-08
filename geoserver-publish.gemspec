
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "geoserver/publish/version"

Gem::Specification.new do |spec|
  spec.name          = "geoserver-publish"
  spec.version       = Geoserver::Publish::VERSION
  spec.authors       = ["Eliot Jordan"]
  spec.email         = ["eliotj@princeton.edu"]

  spec.summary       = "Simple client for publishing Shapefiles and GeoTIFFs to Geoserver"
  spec.description   = "Simple client for publishing Shapefiles and GeoTIFFs to Geoserver"
  spec.homepage      = "https://github.com/samvera-labs/geoserver-publish"
  spec.license       = "Apache-2.0"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.2"

  spec.add_development_dependency "bundler", "> 1.16.0", "< 3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
