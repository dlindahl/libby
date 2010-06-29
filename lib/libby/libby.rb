module Libby
  class <<self
    # This allows users to tell Libby where their Javascript Libraries are located on the local filesystem
    attr_accessor :root
  end

  module Mixins
  end

  module Rails
  end
end

unless Array.new.respond_to?(:extract_options!)
  class Array
    def extract_options!
      last.is_a?(::Hash) ? pop : {}
    end
  end
end

unless String.new.respond_to?(:to_b)
  class String
    def to_b
      self.downcase == 'true'
    end
  end
end

unless nil.respond_to?(:to_b)
  class NilClass
    def to_b
      false
    end
  end
end