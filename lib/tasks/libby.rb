# Downloads each file dependency
def download_library( lib )
  details = lib.download_params
  details[:files].each { |f| get_lib_file( f, details[:save_path] ) }
end

# Uses CURL to fetch the file and unzips it (if neccessary)
# TODO: Add tar support
def get_lib_file( url, save_path )
  FileUtils.makedirs( save_path ) unless File.exists?( save_path )

  filename = url.split('/').last
  %x{ curl #{url} > #{save_path}/#{filename} }

  if filename =~ /\.zip$/
    %x{ cd #{save_path} && unzip #{filename} }
    File.delete "#{save_path}/#{filename}"
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

  end
end
