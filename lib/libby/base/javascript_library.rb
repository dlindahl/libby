class Libby::JavascriptLibrary
  attr_accessor :base_path, :public_path

  def initialize( *args )
    options = args.extract_options!
    self.version = args.first
    @base_path = options[:base_path]
    @public_path = options[:public_path]
  end

  def base_path
    @base_path || self.class::BASE_PATH
  end

  def version
    @version || self.class::MAX_VERSION
  end

  # The name of the Javascript Library
  def name
    self.class::NAME
  end

  def version=( new_version )
    if new_version
      new_version = Versionomy.parse( new_version.to_s )
      if new_version > self.class::MAX_VERSION
        raise( "#{self.class::NAME} version #{new_version.to_s} is not supported. Maximum version available is #{self.class::MAX_VERSION.to_s}")
      else
        @version = new_version
      end
    end
  end

  def public_path
    @public_path || "#{base_path}/#{version.to_s}"
  end

  def include
  end

  def generate_suffix( abbreviated = true )
    @suffix = ''
  end

  private

  def production_env?
    @envs ||= ['production', 'staging', 'test']
    @envs.include?( ::Rails.env.to_s )
  end

  def apply_suffix( delimiter = '', abbreviated = true )
    suffix = self.generate_suffix( abbreviated )
    suffix.blank? ? suffix : "#{delimiter}#{suffix}"
  end

end
