require 'active_support/all' # Really need all? Or just String and Array extensions?
require 'versionomy'

require 'libby/libby'

require 'libby/mixins/library_with_components'
require 'libby/mixins/library_with_core_dependency'
require 'libby/mixins/minifiable_library'
require 'libby/mixins/packable_library'

require 'libby/base/javascript_library'
require 'libby/supported_libraries/ext_js'
require 'libby/supported_libraries/jquery'
require 'libby/supported_libraries/jquery_ui'

# Patch in to ActionView here?
require 'libby/rails/libby_helper'

ActionView::Base.send( :include, Libby::Rails::LibbyHelper )
