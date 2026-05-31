require_relative "lib/database_cloner_rails/version"

Gem::Specification.new do |spec|
  spec.name          = "database-cloner-rails"
  spec.version       = DatabaseClonerRails::VERSION
  spec.authors       = ["Abhishek Sharma"]
  spec.email         = ["abhsss96@gmail.com"]
  spec.summary       = "Rake tasks to dump and restore ActiveRecord data across Rails environments"
  spec.description   = <<~DESC
    database-cloner-rails provides two rake tasks for moving database records between
    Rails environments. `rake database:download` dumps all ActiveRecord model records
    to plain Ruby files (Model.create(...) statements). `rake database:upload` replays
    those files to restore records in the target database.

    Useful for seeding a staging environment from production data, creating snapshots
    before destructive migrations, or sharing realistic test data across a team.

    Supports optional MODELS filtering: `rake database:download MODELS=users,posts`
    to dump only specific tables. The dump directory is created automatically.
  DESC
  spec.homepage      = "https://github.com/abhsss96/database-cloner-rails"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata = {
    "homepage_uri"    => "https://github.com/abhsss96/database-cloner-rails",
    "source_code_uri" => "https://github.com/abhsss96/database-cloner-rails",
    "bug_tracker_uri" => "https://github.com/abhsss96/database-cloner-rails/issues",
    "changelog_uri"   => "https://github.com/abhsss96/database-cloner-rails/releases"
  }

  spec.files         = Dir["lib/**/*", "README.md", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.0"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "activerecord", ">= 5.0"
  spec.add_development_dependency "activesupport", ">= 5.0"
  spec.add_development_dependency "sqlite3", "~> 1.7"
end
