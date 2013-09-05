$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "weirdy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "weirdy"
  s.version     = Weirdy::VERSION
  s.author      = "Bruno Sampietro"
  s.email       = "bsampietro@gmail.com"
  s.homepage    = "http://www.weirdyapp.com"
  s.summary     = "An exception tracker and notification system for Ruby on Rails apps. Manages your application exceptions by the application itself. Provides a panel and an emal notification system."
  s.description = "An exception tracker and notification system for Ruby on Rails apps. Manages your application exceptions by the application itself. Provides a panel and an emal notification system."
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails" #, ">= 3.1.0"
  s.add_dependency "will_paginate", ">= 3.0.0"
  # s.add_dependency "jquery-rails"
  # s.add_dependency "protected_attributes"
end
