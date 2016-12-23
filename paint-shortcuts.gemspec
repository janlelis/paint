# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/paint/shortcuts_version"

Gem::Specification.new do |s|
  s.name        = "paint-shortcuts"
  s.version     = Paint::SHORTCUTS_VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/paint"
  s.summary     = "Terminal painter! Shortcut extension."
  s.description = "Extends the paint gem to support custom color shortcuts."
  s.license = 'MIT'
  s.files = %w[
    paint-shortcuts.gemspec
    lib/paint/shortcuts.rb
    lib/paint/shortcuts_version.rb
  ]
  s.extra_rdoc_files = %w[
    README.md
    SHORTCUTS.md
    CHANGELOG.md
    MIT-LICENSE.txt
  ]

  s.required_ruby_version = '>= 1.9.3'
  s.add_dependency 'paint', '>= 1.0', '< 3.0'
end
