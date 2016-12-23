# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/paint/version"

Gem::Specification.new do |s|
  s.name        = "paint"
  s.version     = Paint::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/paint"
  s.summary     = "Terminal painter!"
  s.description = "Terminal painter: No string extensions / RGB and 256 color support / effect support. Usage: Paint['string', :red, :bright]"
  s.license = 'MIT'

  s.files = %w[
    paint.gemspec
    Rakefile
    .rspec
    .travis.yml
    lib/paint.rb
    lib/paint/pa.rb
    lib/paint/rgb_colors.rb
    lib/paint/constants.rb
    lib/paint/util.rb
    lib/paint/version.rb
    data/rgb_colors.marshal.gz
  ]
  s.extra_rdoc_files = %w[
    README.md
    CHANGELOG.md
    MIT-LICENSE.txt
  ]

  s.required_ruby_version = '>= 1.9.3'
  s.requirements = ['Windows: ansicon (https://github.com/adoxa/ansicon) or ConEmu (http://code.google.com/p/conemu-maximus5)']
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'benchmark-ips', '~> 2.7'
  s.add_development_dependency 'rainbow', '~> 2.1'
  s.add_development_dependency 'term-ansicolor', '~> 1.4'
  s.add_development_dependency 'ansi', '~> 1.5'
  s.add_development_dependency 'hansi', '~> 0.2'
  s.add_development_dependency 'pastel', '~> 0.6'
end
