require "rails"

module DatabaseClonerRails
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../../tasks/database.rake", __dir__)
    end
  end
end
