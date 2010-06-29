class Libby::JqueryUi < Libby::Jquery
  include Libby::Mixins::LibraryWithCoreDependency
  include Libby::Mixins::LibraryWithComponents
  include Libby::Mixins::MinifiableLibrary

  NAME = 'jQuery UI'
  MAX_VERSION = Versionomy.parse('1.8rc3').freeze
  BASE_PATH = 'jquery/ui'
  DEFAULT_CORE_CLASS = 'Jquery'
  CORE_VERSIONS = {
    '1.8rc3' => '1.4.2'
  }

  minifiable true

  attr_accessor :core

  def initialize( *args )
    options = args.extract_options!

    unless options[:core]
      # By default, the jQuery UI Core Library (jQuery) does not support the minification
      options[:core] = { :minified => false } if self.class::CORE_VERSIONS[version.to_s]
    end

    # Put the options back so that "super" can use them
    args.push options
    super( *args )
  end

  def component_base_path( *args )
    "#{public_path}/ui#{apply_suffix( "/", false )}"
  end

  def all_component_group
    "jquery-ui#{apply_suffix('.')}"
  end

  def build_component_filename( type, component )
    "jquery.#{type}.#{component}#{apply_suffix('.')}"
  end

  def components=( *args )
    super
    include_component_core_for 'ui'
    include_component_core_for 'effects'
  end

  def include
    [include_core, include_components].flatten
  end

  private

  def include_component_core_for( comp_type )
    comp_type = comp_type.to_s
    unless @components == 'all'
      if @components.has_type? comp_type
        if comp_type == 'ui' and not @components.components[comp_type][:files].include? 'widget'
          @components.components[comp_type][:files].unshift('widget')
        end
        unless @components.components[comp_type][:files].include? 'core'
          @components.components[comp_type][:files].unshift( 'core' )
        end
      end
    end
  end
end
