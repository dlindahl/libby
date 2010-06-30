# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{libby}
  s.version = "0.0.0.pre2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Derek Lindahl"]
  s.date = %q{2010-06-30}
  s.description = %q{Libby provides an easy way to include the most popular Javascript Libraries in your layouts or views.}
  s.email = %q{dlindahl@customink.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/libby.rb",
     "lib/libby/base/javascript_library.rb",
     "lib/libby/libby.rb",
     "lib/libby/mixins/library_with_components.rb",
     "lib/libby/mixins/library_with_core_dependency.rb",
     "lib/libby/mixins/minifiable_library.rb",
     "lib/libby/mixins/packable_library.rb",
     "lib/libby/rails/libby_controller.rb",
     "lib/libby/rails/libby_helper.rb",
     "lib/libby/supported_libraries/ext_js.rb",
     "lib/libby/supported_libraries/jquery.rb",
     "lib/libby/supported_libraries/jquery_ui.rb",
     "libby.gemspec",
     "test/helper.rb",
     "test/shoulda_macros/libby_macros.rb",
     "test/test_libby.rb"
  ]
  s.homepage = %q{http://github.com/dlindahl/libby}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Libby provides an easy way to include the most popular Javascript Libraries in your layouts or views.}
  s.test_files = [
    "test/helper.rb",
     "test/shoulda_macros/libby_macros.rb",
     "test/test_libby.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<versionomy>, [">= 0.4.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<versionomy>, [">= 0.4.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<versionomy>, [">= 0.4.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

