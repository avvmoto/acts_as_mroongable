$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_mroongable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_mroongable"
  s.version     = ActsAsMroongable::VERSION
  s.authors     = ["avvmoto"]
  s.homepage    = "https://github.com/avvmoto/acts_as_mroongable"
  s.summary     = "A Mroonga plugin for Rails applications."
  s.description = "A Mroonga plugin for Rails applications."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "sqlite3"
end
