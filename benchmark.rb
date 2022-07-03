# frozen_string_literal: true

require 'benchmark/ips'

# - - -

require_relative 'lib/paint'

require 'rainbow'
require 'rainbow/version'

require 'term/ansicolor'

require 'pastel'
pastel = Pastel.new

require 'ansi/code'
require 'ansi/version'

require 'hansi'
require 'hansi/version'

# - - -

puts "# TERMINAL ANSI COLORS BENCHMARK"
puts
puts "  ruby: #{ RUBY_VERSION }"
puts "  paint: #{ Paint::VERSION }"
puts "  rainbow: #{ Rainbow::VERSION }"
puts "  term/ansicolor #{ Term::ANSIColor::VERSION }"
puts "  pastel #{ Pastel::VERSION }"
puts "  ansi #{ ANSI::VERSION }"
puts "  hansi #{ Hansi::VERSION }"
puts
puts "## ONLY FOREGROUND COLOR"
puts

# - - -

Benchmark.ips do |x|
  x.report("paint"){
    Paint['ANSI', :red]
  }

  x.report("paint w/ nesting"){
    Paint%['ANSI', :red]
  }

  x.report("rainbow"){
    Rainbow('ANSI').color(:red)
  }

  x.report("term/ansicolor"){
    Term::ANSIColor.red('ANSI')
  }

  x.report("pastel"){
    pastel.red('ANSI')
  }

  x.report("ansi"){
    ANSI::Code.red('ANSI')
  }

  x.report("hansi"){
    Hansi.render(:red, 'ANSI')
  }

  x.compare!
end

# - - -

puts
puts "## FOREGROUND + BACKGROUND COLOR"
puts

Benchmark.ips do |x|
  x.report("paint"){
    Paint['ANSI', :red, :green]
  }

  x.report("paint w/ nesting"){
    Paint%['ANSI', :red, :green]
  }

  x.report("rainbow"){
    Rainbow('ANSI').fg(:red).bg(:green)
  }

  x.report("term/ansicolor"){
    Term::ANSIColor.red(Term::ANSIColor.on_green('ANSI'))
  }

  x.report("pastel"){
    pastel.red.on_green('ANSI')
  }

  x.compare!
end
