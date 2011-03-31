# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "postrank-api/version"

Gem::Specification.new do |s|
  s.name        = "postrank-api"
  s.version     = PostRank::API::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ilya Grigorik"]
  s.email       = ["ilya@igvita.com"]
  s.homepage    = "http://github.com/postrank-labs/postrank-api"
  s.summary     = "Ruby 1.9 PostRank API Wrapper"
  s.description = s.summary

  s.rubyforge_project = "postrank-api"

  s.add_dependency "postrank-uri"
  s.add_dependency "eventmachine"
  s.add_dependency "em-http-request"
  s.add_dependency "em-synchrony"
  s.add_dependency "yajl-ruby"
  s.add_dependency "chronic"

  s.add_development_dependency "rspec"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end