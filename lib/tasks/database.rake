namespace :database do
  desc "Dump all model records to Ruby files in lib/tasks/database_cloner/db_dump/"
  task download: :environment do
    DatabaseClonerRails::Downloader.run
  end

  desc "Restore model records from dumped Ruby files"
  task upload: :environment do
    DatabaseClonerRails::Uploader.run
  end
end
