require 'rake'
require File.dirname(__FILE__) + '/lib/libby'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "libby"
    gem.summary = %Q{Libby provides an easy way to include the most popular Javascript Libraries in your layouts or views.}
    gem.description = %Q{Libby provides an easy way to include the most popular Javascript Libraries in your layouts or views.}
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

namespace :libby do
  namespace :install do
    desc "Install all support Javascript Libraries"
    task :all do
      [:jquery, :jquery_ui, :ext_js].each do |lib|
        Rake::Task["libby:install:#{lib}"].invoke
      end
    end

    desc "Install the latest version of the jQuery Javascript Library."
    task :jquery do |jq|
      download_library Libby::Jquery
    end

    desc "Install the latest version of the jQuery UI Javascript Library."
    task :jquery_ui do |jq|
      download_library Libby::JqueryUi
    end

    desc "Install the latest version of the ExtJs Javascript Library."
    task :ext_js do |ext|
      puts "NOTE: When unzipped the library, a warning to overwrite existing files may appear. It looksl like Sencha zipped the file incorrectly. It should be safe to accept [A]ll."
      download_library Libby::ExtJs
    end

    # Downloads each file dependency
    def self.download_library( lib )
      details = lib.download_params
      details[:files].each { |f| get_lib_file( f, details[:save_path] ) }
    end

    # Uses CURL to fetch the file and unzips it (if neccessary)
    # TODO: Add tar support
    def self.get_lib_file( url, save_path )
      FileUtils.makedirs( save_path ) unless File.exists?( save_path )

      filename = url.split('/').last
      %x{ curl #{url} > #{save_path}/#{filename} }

      if filename =~ /\.zip$/
        %x{ cd #{save_path} && unzip #{filename} }
        File.delete "#{save_path}/#{filename}"
      end
    end

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
