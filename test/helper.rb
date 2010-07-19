require 'rubygems'
require 'shoulda'
require 'redgreen'

require 'test/unit'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require File.dirname(__FILE__) + '/../init'

# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
# $LOAD_PATH.unshift(File.dirname(__FILE__))

require 'libby'

unless defined?(Rails)
  module Rails
    def self.root
      @rails_root ||= File.expand_path("..")
    end
  end
end

if Libby.root.nil?
  puts "WARNING: The results of these tests will not be complete because you did not tell Libby where your Javascript Libraries are located on the local filesystem." +
        "refer to the README for more information."
end

class Test::Unit::TestCase
end
