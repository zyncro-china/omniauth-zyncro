# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-zyncro/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-zyncro"
  s.version     = OmniAuth::Zyncro::VERSION
  s.authors     = ["David Ruan", "Arun Agrawal"]
  s.email       = ["david.ruan@zyncro-china.com","arunagw@gmail.com"]
  s.homepage    = "https://github.com/arunagw/omniauth-zyncro"
  s.summary     = %q{OmniAuth strategy for Zyncro}
  s.description = %q{OmniAuth strategy for Zyncro}
  s.license     = "MIT"

  s.rubyforge_project = "omniauth-zyncro"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'multi_json', '~> 1.3'
  s.add_runtime_dependency 'omniauth-oauth', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
end
