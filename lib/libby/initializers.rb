# Load each application initializer
Dir["#{File.dirname(__FILE__)}/initializers/*.rb"].sort.each do |path|
  require path
end