GEMSPEC = 'paint.gemspec'

#require 'rake'
#require 'rake/rdoctask'
require 'fileutils'
require 'rspec/core/rake_task'

task :default => :spec
task :test    => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = [
    '--colour',
    '--format documentation',
    '-r ' + File.expand_path( File.join( 'spec', 'spec_helper') ),
  ]
end

def gemspec
  @gemspec ||= eval(File.read(GEMSPEC), binding, GEMSPEC)
end

desc "Build the gem"
task :gem => :gemspec do
  sh "gem build #{GEMSPEC}"
  FileUtils.mkdir_p 'pkg'
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", 'pkg'
end

desc "Install the gem locally"
task :install => :gem do
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}.gem --no-rdoc --no-ri}
end

desc "Generate the gemspec"
task :generate do
  puts gemspec.to_ruby
end

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end

#Rake::RDocTask.new do |rdoc|
#  require File.expand_path( File.join( 'lib',  'paint') )
#
#  rdoc.rdoc_dir = 'doc'
#  rdoc.title = "paint #{Paint::VERSION}"
#  rdoc.rdoc_files.include('README*')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end

desc "Run a Benchmark"
task :benchmark do
  require 'benchmark'
  require 'term/ansicolor'
  class String
    include Term::ANSIColor
  end
  
  require 'rainbow'
  $:.unshift '../lib'
  require 'paint'
  
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
        string.color(colors.next)
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
        string.color(colors.next).background(colors.next)
      end
    end
  end
end
