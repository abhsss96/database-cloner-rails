require_relative "lib/database_cloner_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "database-cloner-rails"
  spec.version       = DatabaseClonerRails::VERSION
  spec.authors       = ["Abhishek Sharma"]
  spec.email         = ["abhsss96@gmail.com"]
  spec.summary       = "Rake tasks to back up and restore database records in Rails"
  spec.description   = "Provides rake tasks to dump all ActiveRecord model records to Ruby files and restore them — useful for seeding staging from production data."
  spec.homepage      = "https://github.com/abhsss96/database-cloner-rails"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.files         = Dir["lib/**/*", "README.md", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "activerecord", ">= 5.0"
  spec.add_development_dependency "activesupport", ">= 5.0"
  spec.add_development_dependency "sqlite3", "~> 1.7"
end
