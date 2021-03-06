require 'rake'
require File.dirname(__FILE__) + '/lib/libby'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "libby"
    gem.summary = %Q{Libby includes Javascript Libraries in your view in just one line.}
    gem.description = %Q{Libby provides an easy way to include the most popular Javascript Libraries in your layouts or views using just one line of code.}
    gem.email = "dlindahl@customink.com"
    gem.homepage = "http://github.com/dlindahl/libby"
    gem.authors = ["Derek Lindahl"]
    gem.add_dependency "activesupport"
    gem.add_dependency "versionomy", ">= 0.4.0"
    gem.add_development_dependency "shoulda"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "libby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# Include the Libby Rake tasks for Gem development
load File.dirname(__FILE__) + '/lib/tasks/libby.rake'