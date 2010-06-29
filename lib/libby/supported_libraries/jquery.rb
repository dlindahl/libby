class Libby::Jquery < Libby::JavascriptLibrary
  include Libby::Mixins::MinifiableLibrary

  NAME = 'jQuery'
  MAX_VERSION = Versionomy.parse('1.4.2').freeze
  BASE_PATH = 'jquery/core'
  MINIFIED_SUFFIX = 'min'

  minifiable true

  def include
    "#{public_path}/jquery-#{version.to_s}#{apply_suffix('.')}.js"
  end
end
