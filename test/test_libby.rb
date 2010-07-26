require File.dirname(__FILE__) + '/helper'

class TestLibby < Test::Unit::TestCase

  context "A Javascript Library named" do
    context "jQuery" do
      context "version" do
        context Libby::Jquery::MAX_VERSION.to_s do
          setup do
            @lib_version = Libby::Jquery::MAX_VERSION.to_s
            @lib = Libby::Jquery.new( Libby::Jquery::MAX_VERSION )
          end
          should "include the library" do
            assert_equal "jquery/core/#{@lib_version}/jquery-#{@lib_version}.min.js", @lib.include
          end
        end
        context Libby::Jquery::MAX_VERSION.bump(:major) do
          should "raise an error because it is supported" do
            assert_raise RuntimeError do
              Libby::Jquery.new( Libby::Jquery::MAX_VERSION.bump(:major) )
            end
          end
        end
      end
      context "UI" do
        context "version" do
          context Libby::JqueryUi::MAX_VERSION.to_s do
            setup do
              @lib = Libby::JqueryUi.new
              @core_version = Libby::JqueryUi::CORE_VERSIONS[@lib.version.to_s]
            end
            should "include the library" do
              files_to_include = @lib.include
              assert_equal ["jquery/ui/#{@lib.version.to_s}/jquery-#{@core_version}.js"], files_to_include
            end
            context "with specified" do
              context "components" do
                setup do
                  @lib = Libby::JqueryUi.new( :components => [ ['ui', ['accordion']] ])
                  @core_version = Libby::JqueryUi::CORE_VERSIONS[@lib.version.to_s]
                end
                should "include the library" do
                  files_to_include = @lib.include
                  assert_equal "jquery/ui/#{@lib.version}/jquery-#{@core_version}.js", files_to_include[0]
                  assert_equal "jquery/ui/#{@lib.version}/ui/minified/jquery.ui.core.min.js", files_to_include[1]
                  assert_equal "jquery/ui/#{@lib.version}/ui/minified/jquery.ui.widget.min.js", files_to_include[2]
                  assert_equal "jquery/ui/#{@lib.version}/ui/minified/jquery.ui.accordion.min.js", files_to_include[3]
                end
              end
              context "ALL components" do
                setup do
                  @lib = Libby::JqueryUi.new :minified => true, :components => :all
                  @core_version = Libby::JqueryUi::CORE_VERSIONS[@lib.version.to_s]
                end
                should "include the library" do
                  files_to_include = @lib.include
                  assert_equal "jquery/ui/#{@lib.version}/jquery-#{@core_version}.js", files_to_include[0]
                  assert_equal "jquery/ui/#{@lib.version}/ui/minified/jquery-ui.min.js", files_to_include[1]
                end
              end
              context "duplicate core" do
                setup do
                  @lib = Libby::JqueryUi.new( :components => [ ['ui', ['core', 'accordion']] ])
                end
                should "not include the core twice" do
                  assert_equal 1, @lib.include.find_all { |f| f =~ /core/ }.size()
                end
              end
              context "effects" do
                setup do
                  @lib = Libby::JqueryUi.new( :components => [ ['effects', ['explode']] ])
                  @core_version = Libby::JqueryUi::CORE_VERSIONS[@lib.version.to_s]
                end
                should "include the library" do
                  files_to_include = @lib.include
                  assert_equal "jquery/ui/#{@lib.version}/jquery-#{@core_version}.js", files_to_include[0]
                  assert_equal "jquery/ui/#{@lib.version}/ui/minified/jquery.effects.core.min.js", files_to_include[1]
                  assert_equal "jquery/ui/#{@lib.version}/ui/minified/jquery.effects.explode.min.js", files_to_include[2]
                end
                context "and is not minified" do
                  setup do
                    @lib = Libby::JqueryUi.new( :minified => false, :components => [ ['effects', ['blind']] ])
                    @core_version = Libby::JqueryUi::CORE_VERSIONS[@lib.version.to_s]
                  end
                  should "include the library" do
                    files_to_include = @lib.include
                    assert_equal "jquery/ui/#{@lib.version}/jquery-#{@core_version}.js", files_to_include[0]
                    assert_equal "jquery/ui/#{@lib.version}/ui/jquery.effects.core.js", files_to_include[1]
                    assert_equal "jquery/ui/#{@lib.version}/ui/jquery.effects.blind.js", files_to_include[2]
                  end
                end
              end
              context "alternate core" do
                setup do
                  @alt_version = '1.3.1'
                  @alt_path = 'jquery/core'
                  @lib = Libby::JqueryUi.new :core => { :version => @alt_version, :base_path => @alt_path }
                end
                should "include the library" do
                  assert_equal "#{@alt_path}/#{@alt_version}/jquery-#{@alt_version}.min.js", @lib.include[0]
                end
              end
            end
          end
          context "1.5.3" do
            context "with alternate core and minified components" do
              setup do
                @ui_version = '1.5.3'
                @alt_version = '1.3.1'
                @alt_path = 'jquery/core'
                @components = [
                  ['ui', ['datepicker', 'dialog']],
                  ['effects', ['fold', 'explode', 'shake']]
                ]
                @lib = Libby::JqueryUi.new(
                  @ui_version,
                  :core => { :version => @alt_version, :base_path => @alt_path },
                  :minified => true,
                  :components => @components
                )
              end
              should "include the library" do
                files_to_include = @lib.include

                assert_equal "#{@alt_path}/#{@alt_version}/jquery-#{@alt_version}.min.js", files_to_include[0]

                component_path = "jquery/ui/#{@ui_version}/ui/minified"
                @components.each do |component_type, components|
                  components.each_with_index do |component, index|
                    #puts "jQuery UI #{lib.version} - Checking for inclusion of: #{component_path}/#{component_type}/#{component_type}.#{component}.min.js"
                    assert files_to_include.include?( "#{component_path}/jquery.#{component_type}.#{component}.min.js" )
                  end
                end
              end
            end
          end
        end
      end
    end
    context "ExtJS" do
      context "version" do
        context Libby::ExtJs::MAX_VERSION.to_s do
          setup do
            @lib = Libby::ExtJs.new
          end
          should "include the library" do
            files_to_include = @lib.include
            assert_equal "extjs/ext-#{@lib.version}/adapter/ext/ext-base.js", files_to_include[0]
            assert_equal "extjs/ext-#{@lib.version}/ext-core.js", files_to_include[1]
          end
          context "with" do
            context "all components" do
              setup do
                @lib = Libby::ExtJs.new :components => :all
              end
              should "include the library" do
                files_to_include = @lib.include
                assert_equal "extjs/ext-#{@lib.version}/ext-all.js", files_to_include[1]
              end
              context "in debug mode" do
                setup do
                  @lib = Libby::ExtJs.new :components => :all_debug
                end
                should "include the library" do
                  files_to_include = @lib.include
                  assert_equal "extjs/ext-#{@lib.version.to_s}/ext-all-debug.js", files_to_include[1]
                end
              end
            end
            context "core components" do
              setup do
                @lib = Libby::ExtJs.new
              end
              should "include the library" do
                files_to_include = @lib.include
                assert_equal "extjs/ext-#{@lib.version.to_s}/ext-core.js", files_to_include[1]
              end
              context "in debug mode" do
                setup do
                  @lib = Libby::ExtJs.new :components => :core_debug
                end
                should "include the library" do
                  files_to_include = @lib.include
                  assert_equal "extjs/ext-#{@lib.version.to_s}/ext-core-debug.js", files_to_include[1]
                end
              end
            end
            context "extra components" do
              setup do
                @lib = Libby::ExtJs.new :components => [ ['util', ['XTemplate', 'TextMetrics', 'KeyMap']], ['data', ['Store']] ]
              end
              should "include the library" do
                files_to_include = @lib.include

                assert_equal "extjs/ext-#{@lib.version.to_s}/adapter/ext/ext-base.js", files_to_include[0]
                assert_equal "extjs/ext-#{@lib.version.to_s}/ext-core.js", files_to_include[1]
                assert_equal "extjs/ext-#{@lib.version.to_s}/build/util/XTemplate-min.js", files_to_include[2]
                assert_equal "extjs/ext-#{@lib.version.to_s}/build/util/TextMetrics-min.js", files_to_include[3]
                assert_equal "extjs/ext-#{@lib.version.to_s}/build/util/KeyMap-min.js", files_to_include[4]
                assert_equal "extjs/ext-#{@lib.version.to_s}/build/data/Store-min.js", files_to_include[5]
              end
              context "that are un-minified" do
                setup do
                  @lib.minified = false
                end
                should "include the library" do
                  files_to_include = @lib.include

                  assert_equal "extjs/ext-#{@lib.version.to_s}/ext-core.js", files_to_include[1]
                  assert_equal "extjs/ext-#{@lib.version.to_s}/source/data/Store.js", files_to_include[5]
                end
              end
            end
            context "the adapter for" do
              context "jQuery" do
                setup do
                  @lib = Libby::ExtJs.new :core => :jquery
                end
                should "include the adapter" do
                  files_to_include = @lib.include
                  assert_equal "extjs/ext-#{@lib.version.to_s}/adapter/jquery/ext-jquery-adapter.js", files_to_include[0]
                end
              end
              context "Prototype" do
                setup do
                  @lib = Libby::ExtJs.new :core => :prototype
                end
                should "include the adapter" do
                  files_to_include = @lib.include
                  assert_equal "extjs/ext-#{@lib.version.to_s}/adapter/prototype/ext-prototype-adapter.js", files_to_include[0]
                end
              end
              context "Y!UI" do
                setup do
                  @lib = Libby::ExtJs.new :core => :yui
                end
                should "include the adapter" do
                  files_to_include = @lib.include
                  assert_equal "extjs/ext-#{@lib.version.to_s}/adapter/yui/ext-yui-adapter.js", files_to_include[0]
                end
              end
            end
          end
        end
      end
    end
  end

end
