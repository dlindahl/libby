class Libby::ExtJs < Libby::JavascriptLibrary
  include Libby::Mixins::LibraryWithCoreDependency
  include Libby::Mixins::LibraryWithPackages
  include Libby::Mixins::DebuggableLibrary

  NAME = 'ExtJS'.freeze
  MAX_VERSION = Versionomy.parse('3.2.1').freeze
  BASE_PATH = 'extjs'.freeze
  MINIFIED_SUFFIX = 'min'.freeze
  DEFAULT_CORE_CLASS = 'ExtJs::Cores::ExtJsBaseCore'.freeze
  PACKAGE_FILE_PATH = 'ext.jsb2'

  debuggable true

  def initialize( *args )
    options = args.extract_options!
    options[:packages] ||= []
    options[:packages] = [ options[:packages] ] unless options[:packages].is_a? Array
    # Auto-include Ext All if no packages are specified
    if options[:packages].empty?
      options[:packages] << 'Ext All'
    end

    # Re-map the Core specification to a Ruby Class (or set the default if missing)
    if options[:core]
      options[:core] = { :class => "ExtJs::Cores::#{options[:core].to_s.classify}Core" } unless options[:core].is_a? Hash
    else
      options[:packages].unshift('Ext Base')
    end

    args.push options
    super *args
  end

  def public_path
    "#{base_path}/ext-#{version.to_s}"
  end

  def adapter
    @core.class::NAME
  end

  def package_base_path( type = nil)
    public_path
  end

  def package_payload
    File.join(Rails.root, '/', Libby.root, '/', public_path, PACKAGE_FILE_PATH)
  end

  def include_adapter
    # ExtJsBaseCore does not require an adapter
    @core.class.to_s =~ %r{ExtJsBaseCore} ? nil : "#{@core.path}/ext-#{@core.name}-adapter#{apply_suffix('-')}.js"
  end

  def include
    [include_core, include_adapter, include_packages].flatten.compact.uniq
  end

  def self.download_params
    lib_name = NAME.downcase
    version = MAX_VERSION.to_s

    url = "http://extjs.cachefly.net/"

    {
      :name => lib_name,
      :version => version,
      :files => [ "#{url}/ext-#{version}.zip" ],
      :save_path => "#{Libby.root}/#{lib_name}"
    }
  end

end

module Libby::ExtJs::Cores
  class Base < Libby::JavascriptLibrary
    MAX_VERSION = Libby::ExtJs::MAX_VERSION
    BASE_PATH = Libby::ExtJs::BASE_PATH
    MINIFIED_SUFFIX = Libby::ExtJs::MINIFIED_SUFFIX

    def name
      n = (self.class.const_defined?('NAME') ? self.class::NAME.downcase : self.class.to_s.match(/(?:::)(\w+)$/)[1])
      (n.gsub 'Core', '').downcase
    end

    def path
      "#{public_path}/adapter/#{name}"
    end
  end

  class ExtJsBaseCore < Base
    NAME = 'Ext'

    def include
    end
  end

  class JqueryCore < Base
    def include
      []
    end
  end

  class PrototypeCore < Base
    def include
      []
    end
  end

  class YuiCore < Base
    def include
      []
    end
  end
end
