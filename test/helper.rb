require 'rubygems'
require 'shoulda'
require 'redgreen'

require 'test/unit'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require File.dirname(__FILE__) + '/../init'

require 'libby'

unless defined?(Rails)
  module Rails
    def self.root
      @rails_root ||= File.expand_path("..")
    end
    def self.env
      Libby::Test::Env.new
    end
  end
  module Libby
    module Test
      class Env
        def to_s
          'test'
        end
        def test?
          true
        end
        # Stub environment calls
        def method_missing( method_id, *args )
          method_id.to_s =~ /\w\?$/ ? false : super
        end
      end
    end
  end
end

# Override the Package Payload for ExtJs so we don't have to manually specify it each time in the tests.
module Libby
  class ExtJs
    def package_payload
      File.dirname(__FILE__) + "/fixtures/extjs/ext.jsb2"
    end
  end
end

if Libby.root.nil?
  puts "WARNING: The results of these tests will not be complete because you did not tell Libby where your Javascript Libraries are located on the local filesystem." +
        "refer to the README for more information."
end

class Test::Unit::TestCase
end
