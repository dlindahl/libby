module Libby::Rails::LibbyHelper

  def compose_library( library_name, *args )
    "Libby::#{library_name.camelize}".constantize.new *args
  end

  # Returns TRUE if the indicated library has already been included
  # [lib_name] String *or* Libby::JavascriptLibrary Instance
  # [version] Optional. If an instance of Libby::JavascriptLibrary is provided, the version will automatically be checked
  # [return] Boolean
  # ---
  def library_included?( lib_name, version = nil )
    @included_libraries ||= {}
    
    if lib_name.is_a? Libby::JavascriptLibrary
      version = lib_name.version
      lib_name = lib_name.name
    end

    if @included_libraries.has_key? lib_name
      # Check the version of the included library as well (if provided)
      (version) ? @included_libraries[lib_name].include?( version ) : true
    end
  end

  def include_js_library( library_name, *args )
    lib = compose_library( library_name, *args )

    # If the library exists and has not already been included, include it. This helps prevents views from including a library more than one time on a page.
    if lib and not library_included? lib
      add_included_library( lib )
      files_to_include = lib.include
      javascript_include_tag *files_to_include unless files_to_include.empty?
    end
  end

  def method_missing( method_id, *args )
    if match = /^include_(\w+)/.match(method_id.to_s)
      library_name = match.captures.first
      include_js_library library_name, *args
    end
  end

  private

  # Add the designated library to the list of previously included libraries.
  def add_included_library( lib )
    @included_libraries ||= {}

    @included_libraries[lib.name] ||= []
    @included_libraries[lib.name] << lib.version

    # If the library contains a core dependency, make sure that is included as well
    add_included_library( lib.core ) if lib.respond_to? :core
  end

end
