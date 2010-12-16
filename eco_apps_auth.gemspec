spec = Gem::Specification.new do |s| 
  s.name = "eco_apps_auth"
  s.version = "0.2.0"
  s.author = "Eleutian Technology, LLC"
  s.email = "dev@eleutian.com"
  s.homepage = "https://github.com/eleutian/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Eco Apps Authentication"
  %w{lib app config}.each{|folder|
    s.files += Dir["#{folder}/**/*"]
  }
  s.require_path = "lib"
  s.autorequire = "eco_apps_auth"
  s.test_files = Dir["{spec}/**/*"]
  s.add_dependency("eco_apps", ">= 0.2.0")
end

