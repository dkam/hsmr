# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hsmr/version"

Gem::Specification.new do |s|
  s.name        = "HSMR"
  s.version     = HSMR::VERSION
  s.authors     = ["Dan Milne"]
  s.email       = ["d@nmilne.com"]
  s.homepage    = ""
  s.summary     = %q{HSM commands in Ruby}
  s.description = %q{A collection of methods usually implemented in a HSM (Hardware Security Module)}

  s.rubyforge_project = "hsmr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_development_dependency "guard-test, factory_girl"
end