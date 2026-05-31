namespace :database do
  desc "Dump all model records to Ruby files in lib/tasks/database_cloner/db_dump/. Use MODELS=users,posts to filter."
  task download: :environment do
    only = ENV["MODELS"]&.split(",")&.map(&:strip)
    DatabaseClonerRails::Downloader.run(only: only)
  end

  desc "Restore model records from dumped Ruby files. Use MODELS=users,posts to filter."
  task upload: :environment do
    only = ENV["MODELS"]&.split(",")&.map(&:strip)
    DatabaseClonerRails::Uploader.run(only: only)
  end
end
