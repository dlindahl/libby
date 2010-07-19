class Libby::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/libby.rb'
  end
end if defined?(Rails::Railtie)