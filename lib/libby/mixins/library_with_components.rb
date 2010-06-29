module Libby::Mixins::LibraryWithComponents
  def initialize( *args )
    super
    options = args.last.is_a?(Hash) ? args.pop : {} # TODO: Change this to args.extract_options! when upgraded to Rails 2
    @components = LibraryComponents.new
    self.components = options[:components]
  end

  def components=( components = {} )
    return if components.nil?
    if components.is_a? Array
      components.each do |component_type, comps|
        if comps.is_a? Array
          comps.each do |component|
            @components.add component_type, component
          end
        else
          @components.add component_type, comps
        end
      end
    elsif components.is_a? String or components.is_a? Symbol
      @components = components.to_s
    end
  end

  def include_components
     components = []
     if @components.is_a? String
       filename = self.send "#{@components}_component_group"
       components << "#{component_base_path(@components)}/#{filename}.js"
     else
      @components.each do |component_type, component|
        # Allow inclusion of combined XXX_component files in addition to individually specificed files
        unless component.is_a? String
          filename = (self.send( "#{component_type}_component_group" ) << ".js")
        else
          filename = "#{build_component_filename(component_type, component)}.js"
        end
        components << "#{component_base_path(component_type)}/#{filename}"
      end
    end
    components
  end

  def build_component_filename( *args )
  end

  # Modeled after ActiveRecord::Base::Errors
  class LibraryComponents
    include Enumerable

    attr_accessor :components

    def initialize
      @sorted = true
      @load_order_counter = 0
      @components = {}
    end

    def next_load_order
      @load_order_counter = @load_order_counter.next
      @load_order_counter
    end

    def add( comp_type, comp )
      @components[comp_type.to_s] = { :files => [], :order => nil } if @components[comp_type.to_s].nil?
      # Set the load order to the value passed in or default to 0 to make sure it is loaded as soon as possible
      @components[comp_type.to_s][:order] = comp.is_a?(Integer) ? comp : (comp.nil? ? 0 : next_load_order)
      @components[comp_type.to_s][:files] << comp unless @components[comp_type.to_s][:files].include? comp
      @sorted = false
    end

    def each
      # Sort by Load Order( as needed )
      @components = @components.sort{|a,b| a[1][:order] <=> b[1][:order]} unless @sorted
      @sorted = true
      @components.each do |comp_type, comps|
        comps[:files].each { |comp| yield comp_type, comp }
      end
    end

    def empty?
      @components.empty?
    end

    # Removes all the components that have been added.
    def clear
      initialize
    end

    # Returns the total number of components added.
    def size
      @components.values.inject(0) { |component_count, attribute| component_count + attribute.size }
    end

    def has_type?( comp_name )
      @components.has_key? comp_name.to_s
    end

    def has_file?( comp )
      file_included = false
      @components.each do |comp_type, comps|
        if comps.include? comp
          file_included = true 
          break
        end
      end
      file_included
    end

    alias_method :count, :size
    alias_method :length, :size

  end
end