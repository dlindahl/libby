class Libby::Jquery < Libby::JavascriptLibrary
  include Libby::Mixins::MinifiableLibrary

  NAME = 'jQuery'.freeze
  MAX_VERSION = Versionomy.parse('1.4.2').freeze
  BASE_PATH = 'jquery/core'.freeze
  MINIFIED_SUFFIX = 'min'.freeze

  minifiable true

  def include
    "#{public_path}/jquery-#{version.to_s}#{apply_suffix('.')}.js"
  end

  def self.download_params
    lib_name = NAME.downcase
    version = MAX_VERSION.to_s

    url = "http://code.jquery.com"

    {
      :name => lib_name,
      :version => version,
      :files => [ "#{url}/#{lib_name}-#{version}.min.js", "#{url}/#{lib_name}-#{version}.js" ],
      :save_path => "#{Libby.root}/#{lib_name}/core/#{version}"
    }
  end

end
