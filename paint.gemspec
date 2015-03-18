# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/paint/version"

Gem::Specification.new do |s|
  s.name        = "paint"
  s.version     = Paint::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/paint"
  s.summary     = "Terminal painter!"
  s.description = "Terminal painter / no string extensions / 256 color support / effect support / define custom shortcuts / basic usage: Paint['string', :red, :bright]"
  s.required_ruby_version     = '>= 1.9.3'
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c}]) + %w{Rakefile paint.gemspec}
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE.txt"]
  s.license = 'MIT'

  s.add_development_dependency 'rspec', '>= 3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rainbow', '1.1.4'
  s.add_development_dependency 'term-ansicolor'
end
