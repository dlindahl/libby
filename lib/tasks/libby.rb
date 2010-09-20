# Downloads each file dependency
def download_library( lib )
  details = lib.download_params
  details[:files].each do |file_to_dl|
    if file_to_dl.is_a? Array
      f = file_to_dl[0]
      save_path = details[:save_path] + "/" + file_to_dl[1]
    else
      f = file_to_dl
      save_path = details[:save_path]
    end

    get_lib_file( f, save_path )
  end
end

# Uses CURL to fetch the file and unzips it (if neccessary)
# TODO: Add tar support
def get_lib_file( url, save_path )
  FileUtils.makedirs( save_path ) unless File.exists?( save_path )

  filename = url.split('/').last
  puts ""
  puts "=> Downloading #{filename} from #{url}"
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
      [:jquery, :jquery_ui, :ext_js, :ext_core].each do |lib|
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
      puts "NOTE: When unzipping the library, a warning to overwrite existing files may appear. It looksl like Sencha zipped the file incorrectly. It should be safe to accept [A]ll."
      download_library Libby::ExtJs
    end

    desc "Install the latest version of the Ext Core Javascript Library."
    task :ext_core do |ext|
      download_library Libby::ExtCore
    end

    desc "Install the latest version of the RequireJS Library"
    task :require_js do |require|
      puts ""
      puts "NOTE: Because of how RequireJS works, the files must be in public/javascripts. After the library has been downloaded, a symlink to the most recent version will be created for you."

      download_library Libby::RequireJs

      min_lib = Libby::RequireJs.new(:minified => true).include.split('/').last
      lib = Libby::RequireJs.new(:minified => false).include.split('/').last

      FileUtils.ln_s( "requirejs/#{Libby::RequireJs::MAX_VERSION.to_s}/minified/#{lib}", "#{Libby.root}/#{min_lib}", :force => true)
      FileUtils.ln_s( "requirejs/#{Libby::RequireJs::MAX_VERSION.to_s}/#{lib}", "#{Libby.root}/#{lib}", :force => true)
    end

  end
end
