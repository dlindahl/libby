module Libby::Mixins::DebuggableLibrary
  const_set( 'DEBUGGED_SUFFIX', 'debug' ) unless const_defined? 'DEBUGGED_SUFFIX'

  attr_accessor :debugged
  attr_reader :debuggable

  def self.included( klass )
    klass.extend ClassMethods
  end

  def initialize( *args )
    options = args.extract_options!
    self.debugged = options[:debug].to_s.to_b unless options[:debug].nil?
    args.push options
    super *args
  end

  def debugged
    (@debugged.nil? ? (not production_env?) : @debugged) if debuggable?
  end
  alias :debugged? :debugged

  def generate_suffix( *args )
    super
    @suffix = DEBUGGED_SUFFIX if debugged?
    @suffix
  end

  def debuggable?
    true
  end

  module ClassMethods
    def debuggable( is_debuggable = true )
      @debuggable = is_debuggable.nil? ? false : is_debuggable
    end
  end

end