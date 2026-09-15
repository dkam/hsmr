# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hsmr/version"

Gem::Specification.new do |s|
  s.name        = "hsmr"
  s.version     = HSMR::VERSION
  s.authors     = ["Dan Milne"]
  s.email       = ["d@nmilne.com"]
  s.homepage    = 'https://github.com/dkam/hsmr'
  s.summary     = %q{HSM commands in Ruby}
  s.description = %q{A collection of methods usually implemented in a HSM (Hardware Security Module)}
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake", '~> 13'
  s.add_development_dependency "minitest", "~> 5.25"
end
