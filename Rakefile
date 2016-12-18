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
  ruby 'benchmark.rb'
end

desc "Print 256 colors rainbow"
task :rainbow256 do
  require_relative 'lib/paint'
  (0...256).each{ |color|
    print Paint[' ', 48, 5, color] # print empty bg color field
  }
  puts
end
