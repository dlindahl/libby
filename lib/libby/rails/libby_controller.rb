# TODO: This should probably be written as Middleware, but I don't really know how that works
module Libby::Rails::LibbyController
  include Libby::Rails::LibbyHelper

  caches_action_with_parameters :index, :parameters => [:version, :minified, :packable, :components]

  def index
    if params[:library_name]
      @cfg = {}.merge(params)
      @cfg.symbolize_keys!
      @cfg.delete(:controller)
      @cfg.delete(:action)
      library_name = @cfg.delete(:library_name)
      version = @cfg.delete(:version) if @cfg[:version]

      # Library Components Group Sets are specified by a space delimited string.
      # Library Component Groups are specified by a | (pipe) delimeted string
      # Individual Library Component Files are specified by a , (comma) delimeted string
      # Usage:
      # "ui|tabs,accordion effects|explode,blind" would load the UI and Effects Component Groups
      # and include the UI files 'tabs' and 'accordion', and the Effects files 'explode' and 'blind'
      if @cfg[:components]
        components = @cfg[:components].split(' ')
        if @cfg[:components].include? '|'
          @cfg[:components] = []
          components.each do |component|
            component = component.split('|')
            @cfg[:components] << [ component[0], component[1].split(',')]
          end
        else
          @cfg[:components] = components.size > 1 ? components : components.first
        end
      end

      @lib = compose_library library_name, version, @cfg
      render :template => 'javascript_library/index', :content_type => Mime::JS
    end
  end
end