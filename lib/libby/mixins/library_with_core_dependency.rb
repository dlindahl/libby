# A Mixin to add additional functions to assist a Library that requires a core library to fully operate.
module Libby::Mixins::LibraryWithCoreDependency
  def initialize( *args )
    super
    options = args.last.is_a?(Hash) ? args.pop : {} # TODO: Change this to args.extract_options! when upgraded to Rails 2
    @core_config ||= {}

    if options[:core]
      @core_version = options[:core][:version]
      @core_config = options[:core]
    end
    build_core
  end

  def include_core
    build_core # rebuild core if any core config options have changed
    @core.include
  end

  private

  def build_core
    @core_version ||= (self.class.const_defined? 'CORE_VERSIONS') ? self.class::CORE_VERSIONS[version.to_s] : version.to_s
    @core_config ||= {}
    @core_config[:public_path] ||= self.public_path unless @core_config[:base_path]
    # TODO: Remove?
    @core_config[:minified] = minified? if self.respond_to?( :minified? ) and @core_config[:minified].nil?

    @core = ("Libby::" + (@core_config[:class] || self.class::DEFAULT_CORE_CLASS)).constantize.new(@core_version, @core_config)
  end
end