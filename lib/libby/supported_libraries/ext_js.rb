class Libby::ExtJs < Libby::JavascriptLibrary
  include Libby::Mixins::LibraryWithCoreDependency
  include Libby::Mixins::LibraryWithComponents
  include Libby::Mixins::MinifiableLibrary

  NAME = 'ExtJS'.freeze
  MAX_VERSION = Versionomy.parse('3.0-rc2').freeze
  BASE_PATH = 'extjs'.freeze
  MINIFIED_SUFFIX = 'min'.freeze
  DEFAULT_CORE_CLASS = 'ExtJs::Cores::ExtJsCore'.freeze
  STANDARD_COMPONENTS = [ 'all', 'all_debug', 'core', 'core_debug'].freeze
  LOAD_ORDER = {
    :core => ['Ext', 'DomHelper', 'Template', 'DomQuery', 'util/Observable', 'EventManager', 'Element', 'Fx', 'CompositeElement', 'data/Connection', 'UpdateManager', 'util/DelayedTask', '']
  }

  minifiable true

  def initialize( *args )
    options = args.last.is_a?(Hash) ? args.pop : {} # TODO: Change this to args.extract_options! when upgraded to Rails 2
    if options[:core]
      options[:core] = { :class => "ExtJs::Cores::#{options[:core].to_s.classify}Core" } unless options[:core].is_a? Hash
    end
    options[:components] ||= :core
    # If the CORE files were not specified, automatically include them
    if options[:components].is_a? Array and not options[:components].flatten.include? 'core'
      options[:components] << ['core']
    end
    args.push options
    super( *args )
  end

  def public_path
    "#{base_path}/ext-#{version.to_s}"
  end

  def adapter
    @core.class::NAME
  end

  def component_base_path( type = nil)
    path = public_path
    if type and not STANDARD_COMPONENTS.include? type
      path << "/#{(minified?) ? 'build' : 'source'}"
    end
    path
  end

  def all_component_group
    "ext-all"
  end

  def all_debug_component_group
    "ext-all-debug"
  end

  def core_component_group
    "ext-core"
  end

  def core_debug_component_group
    "ext-core-debug"
  end

  def build_component_filename( type, component )
    "#{type}/#{component}#{apply_suffix('-')}"
  end

  def include_adapter
    # ExtJsCore does not require an adapter
    @core.class.to_s == 'Libby::ExtJs::Cores::ExtJsCore' ? [] : "#{@core.path}/ext-#{@core.name}-adapter.js" 
  end

  def include
    [include_core, include_adapter, include_components].flatten
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

  class ExtJsCore < Base
    NAME = 'Ext'

    def include
      "#{path}/ext-base.js"
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
