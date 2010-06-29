module Libby::Mixins::PackableLibrary
  const_set( 'PACKED_SUFFIX', 'packed' ) unless const_defined? 'PACKED_SUFFIX'
  attr_accessor :packed
  attr_reader :packable

  def self.included( klass )
    klass.extend ClassMethods
  end

  def initialize( *args )
    super
    options = args.last.is_a?(Hash) ? args.pop : {} # TODO: Change this to args.extract_options! when upgraded to Rails 2
    self.packed = options[:packed].to_s.to_b unless options[:packed].nil?
  end

  def packable?
    self.class.instance_variable_get('@packable')
  end

  def packed
    # Pack the library unless Minification is supported and *explicitly* turned on
    if self.respond_to?(:minifiable)
      is_minified = @minified.nil? ? false : @minified
    else
      is_minified = false
    end
    (@packed.nil? ? (production_env? and not is_minified) : @packed) if packable?
  end
  alias :packed? :packed

  def generate_suffix( abbreviated = true )
    super( abbreviated )
    @suffix = PACKED_SUFFIX if packed?
    @suffix
  end

  module ClassMethods
    def packable( is_packable )
      @packable = is_packable.nil? ? false : is_packable
    end
  end
end