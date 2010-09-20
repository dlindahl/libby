module Libby::Mixins::LibraryWithPackages

  class PackageNotFound < StandardError; end

  def initialize( *args )
    options = args.extract_options!
    @packages = []
    @package_payload_path = options[:package_paylod] || self.package_payload
    @package_payload = File.read( @package_payload_path )
    @package_payload = @package_payload ? JSON.parse( @package_payload ) : {}
    self.packages = options[:packages]
    args.push options
    super *args
  end

  def packages=( packages = {} )
    return if packages.nil?

    packages = [ packages ] unless packages.is_a? Array

    packages.each do |pkg_name|
      pkg = find_package( pkg_name )
      if pkg
        append_package( pkg )
      else
        raise PackageNotFound, %Q{Could not find the package "#{pkg_name}" in the Package Payload file (#{@package_payload_path})}
      end
    end
  end

  def include_packages
    @packages
  end

  private

  def find_package( pkg_name )
    pkg_name.gsub!(/^\//,'')
    @package_payload['pkgs'].find do |pkg|
      pkg['name'] == pkg_name || pkg['file'] =~ Regexp.new(pkg_name)
    end
  end

  def append_package( pkg )
    unless pkg['includeDeps']
      pkg['pkgDeps'].each { |pkg_dep| append_package( find_package( pkg_dep )) } if pkg['pkgDeps']
      pkg['pkgs'].each { |pkg_dep| append_package( find_package( pkg_dep )) } if pkg['pkgs']
    end
    pkg_file = "#{package_base_path}/#{pkg['file'].gsub(/\.js$/,'')}"
    pkg_file << "#{apply_suffix('-')}.js"
    @packages << pkg_file unless @packages.include? pkg_file
  end

end