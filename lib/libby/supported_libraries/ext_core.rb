class Libby::ExtCore < Libby::JavascriptLibrary
  include Libby::Mixins::DebuggableLibrary

  NAME = 'Ext Core'.freeze
  MAX_VERSION = Versionomy.parse('3.1.0').freeze
  BASE_PATH = 'extjs/core'.freeze

  debuggable true

  def public_path
    "#{base_path}/ext-core-#{version.to_s}"
  end

  def include
    "#{public_path}/ext-core#{apply_suffix('-')}.js"
  end

  def self.download_params
    lib_name = NAME.downcase
    version = MAX_VERSION.to_s

    url = "http://dev.sencha.com/deploy"

    {
      :name => lib_name,
      :version => version,
      :files => [ "#{url}/ext-core-#{version}.zip" ],
      :save_path => "#{Libby.root}/extjs/core/"
    }
  end

  def self.cleanup_download
    
  end

end
