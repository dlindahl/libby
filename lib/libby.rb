require 'active_support/all' # Really need all? Or just String and Array extensions?
require 'versionomy'

require File.dirname(__FILE__) + '/libby/libby'

require File.dirname(__FILE__) +  '/libby/mixins/library_with_components'
require File.dirname(__FILE__) +  '/libby/mixins/library_with_core_dependency'
require File.dirname(__FILE__) +  '/libby/mixins/minifiable_library'
require File.dirname(__FILE__) +  '/libby/mixins/packable_library'

require File.dirname(__FILE__) +  '/libby/base/javascript_library'
require File.dirname(__FILE__) +  '/libby/supported_libraries/ext_js'
require File.dirname(__FILE__) +  '/libby/supported_libraries/jquery'
require File.dirname(__FILE__) +  '/libby/supported_libraries/jquery_ui'

# Patch in to ActionView here?
require File.dirname(__FILE__) +  '/libby/rails/libby_helper'

ActionView::Base.send( :include, Libby::Rails::LibbyHelper ) if defined?(ActionView)
