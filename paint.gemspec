# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/paint/version"
 
Gem::Specification.new do |s|
  s.name        = "paint"
  s.version     = Paint::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/paint"
  s.summary     = "Yet another terminal colors gem"
  s.description =  "Yet another terminal colors gem / no string extensions / 256 color support / effect support / define custom shortcuts"
  s.required_ruby_version     = '>= 1.8.7'
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c}]) + %w{Rakefile paint.gemspec .gemtest}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rake'
 
  len = s.homepage.size
  s.post_install_message = \
   ("       ┌── " + "info ".ljust(len-2,'%')            + "─┐\n" +
    " J-_-L │ "   + s.homepage                          + " │\n" +
    "       ├── " + "usage ".ljust(len-2,'%')           + "─┤\n" +
    "       │ "   + "require 'paint'".ljust(len,' ')    + " │\n" +
    "       │ "   + "puts Paint['J-_-L', :red] # \e[31mJ-_-L\e[0m".ljust(len,' ')         + " │\n" +
    "       └─"   + '─'*len                             + "─┘").gsub('%', '─') # 1.8 workaround
end
