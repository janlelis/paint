require 'fileutils'
require 'rspec/core/rake_task'

gemspecs = %w[
  paint.gemspec
  paint-shortcuts.gemspec
]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = [
    '--colour',
    '--format documentation',
    '-r ' + File.expand_path( File.join( 'spec', 'spec_helper') ),
  ]
end

task :default => :spec
task :test    => :spec

def gemspec_spec_for(gemspec)
  eval(File.read(gemspec), binding, gemspec)
end

desc "Build the gems"
task :gems do
  FileUtils.mkdir_p 'pkg'
  gemspecs.each{ |gemspec|
    sh "gem build #{gemspec}"
    spec = gemspec_spec_for(gemspec)
    FileUtils.mv "#{spec.name}-#{spec.version}.gem", 'pkg'
  }
end

desc "Install the gem locally"
task :install => :gems do
  gemspecs.each{ |gemspec|
    spec = gemspec_spec_for(gemspec)
    sh %{gem install pkg/#{spec.name}-#{spec.version}.gem --no-rdoc --no-ri}
  }
end

desc "Run a Benchmark"
task :benchmark do
  require 'benchmark'
  require 'term/ansicolor'
  class String
    include Term::ANSIColor
  end

  require 'rainbow'
  require_relative 'lib/paint'

  n = 100_000
  colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan]
  def colors.next
    @index ||= 0
    at((@index += 1) % size)
  end
  Benchmark.bmbm 30 do |results|
    string = 'Ruby is awesome!'

    results.report 'cycle' do
      n.times do
        colors.next
      end
    end

    results.report 'paint' do
      n.times do
        Paint[string, colors.next]
      end
    end

    results.report 'term-ansicolor' do
      n.times do
        string.send(colors.next)
      end
    end

    results.report 'rainbow' do
      n.times do
        Rainbow(string).color(colors.next)
      end
    end

    results.report 'paint with background' do
      n.times do
        Paint[string, colors.next, colors.next]
      end
    end

    results.report 'term-ansicolor with background' do
      n.times do
        string.send(colors.next).send("on_#{colors.next}")
      end
    end

    results.report 'rainbow with background' do
      n.times do
        Rainbow(string).color(colors.next).background(colors.next)
      end
    end
  end
end
