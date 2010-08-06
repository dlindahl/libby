class Libby::RequireJs < Libby::JavascriptLibrary
  include Libby::Mixins::MinifiableLibrary

  NAME = 'RequireJs'.freeze
  MAX_VERSION = Versionomy.parse('0.12.0').freeze
  BASE_PATH = 'require_js'.freeze
  MINIFIED_SUFFIX = 'min'.freeze

  minifiable true

  def include
    "#{Libby.root.gsub('public','')}/require#{apply_suffix('.')}.js"
  end

  def self.download_params
    lib_name = NAME.downcase
    version = MAX_VERSION.to_s

    url = "http://requirejs.org/docs/release/#{version}"

    files = []
    ['comments','minified'].each do |type|
      urls = [ 'require', 'allplugins-require', 'transportD-require'].collect do |component|
        path = "#{url}/#{type}/#{component}.js"
        path = [path,"minified"] if type == "minified"
        path
      end

      files.concat urls
    end

    {
      :name => lib_name,
      :version => version,
      :files => files,
      :save_path => "#{Libby.root}/#{lib_name}/#{version}"
    }
  end

end