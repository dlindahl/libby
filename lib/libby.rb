require 'active_support/all' # Really need all? Or just String and Array extensions?
require 'versionomy'

require File.dirname(__FILE__) + '/libby/libby'

Dir["#{File.dirname(__FILE__)}/libby/mixins/*.rb"].sort.each do |path|
  require path
end

require File.dirname(__FILE__) +  '/libby/base/javascript_library'
Dir["#{File.dirname(__FILE__)}/libby/supported_libraries/*.rb"].sort.each do |path|
  require path
end

# Patch in to ActionView here?
require File.dirname(__FILE__) +  '/libby/rails/libby_helper'

ActionView::Base.send( :include, Libby::Rails::LibbyHelper ) if defined?(ActionView)

require File.dirname(__FILE__) + '/libby/initializers'