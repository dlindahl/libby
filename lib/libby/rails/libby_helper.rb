module Libby::Rails::LibbyHelper

  def compose_library( library_name, *args )
    "Libby::#{library_name.camelize}".constantize.new *args
  end

  # Returns TRUE if the indicated library has already been included
  # [lib_name] String *or* Libby::JavascriptLibrary Instance
  # [version] Optional. If an instance of Libby::JavascriptLibrary is provided, the version will automatically be checked
  # [return] Boolean
  # ---
  def library_included?( lib, version = nil )
    @included_libraries ||= {}

    if @included_libraries.has_key? lib.name
      # Check the version of the included library as well (if provided)
      (version) ? @included_libraries[lib.name].include?( version ) : true
    end
  end

  def include_js_library( library_name, *args )
    options = args.extract_options!

    force_include = options.delete(:force_include) if options.has_key? :force_include

    args << options

    lib = compose_library( library_name, *args )

    # If the library exists and has not already been included, include it. This helps prevents views from including a library more than one time on a page.
    if lib and ( force_include or not library_included?(lib) )
      add_included_library( lib )
      files_to_include = lib.include
      if files_to_include and not files_to_include.empty?
        javascript_include_tag *files_to_include
      end
    end
  end

  def method_missing( method_id, *args )
    if match = /^include_(\w+)/.match(method_id.to_s)
      library_name = match.captures.first
      include_js_library( library_name, *args )
    else
      super
    end
  end

  private

  # Add the designated library to the list of previously included libraries.
  def add_included_library( lib )
    @included_libraries ||= {}

    if lib
      @included_libraries[lib.name] ||= []
      @included_libraries[lib.name] << lib.version

      # If the library contains a core dependency, make sure that is included as well
      add_included_library( lib.core ) if lib.respond_to? :core
    else
      logger.warn("WARNING: A view has attempted to include a nil library!")
    end
  end

end
