module LibbyMacros

  def should_reference_files_that_exist( files )
    should "reference files that actually exist in the file system" do
      if Libby.root
        files = eval(files, self.send(:binding), __FILE__, __LINE__) if files.is_a?(String)
        files.each do |filename|
          path = "#{Libby.root}/#{filename.split('?').first}"
          exists = File.exist?( path )
          puts "#{path} not found!" unless exists
          assert exists
        end
      end
    end
  end

end

class Test::Unit::TestCase
  extend LibbyMacros
end
