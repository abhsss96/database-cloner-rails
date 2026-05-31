require 'database-cloner-rails'
require 'rails'
module DatabaseClonerRails
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'lib/tasks/database.rake'
    end
  end
end
