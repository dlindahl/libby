module Libby::Mixins::MinifiableLibrary
  const_set( 'MINIFIED_SUFFIX', 'minified' ) unless const_defined? 'MINIFIED_SUFFIX'
  const_set( 'ABBREVIATED_MINIFIED_SUFFIX', 'min' ) unless const_defined? 'ABBREVIATED_MINIFIED_SUFFIX'
  attr_accessor :minified
  attr_reader :minifiable

  def self.included( klass )
    klass.extend ClassMethods
  end

  def initialize( *args )
    super
    options = args.last.is_a?(Hash) ? args.pop : {} # TODO: Change this to args.extract_options! when upgraded to Rails 2
    self.minified = options[:minified].to_s.to_b unless options[:minified].nil?
  end

  def minifiable?
    true
  end

  def minified=( minify )
    @minified = minify
    if respond_to?(:packable?)
      # Turn off packing if we are specifically minifying the library
      self.packed = false
    end
  end

  def minified
    is_packed = self.respond_to?(:packable?) ? packed? : false # Don't minify if packing is supported and turned on
    (@minified.nil? ? (production_env? and !is_packed) : @minified) if minifiable?
  end
  alias :minified? :minified

  def generate_suffix( abbreviated = true )
    super( abbreviated )
    @suffix = ( abbreviated ? ABBREVIATED_MINIFIED_SUFFIX : MINIFIED_SUFFIX ) if minified?
    @suffix
  end

  module ClassMethods
    def minifiable( is_minifiable = true )
      @minifiable = is_minifiable.nil? ? false : is_minifiable
    end
  end
end