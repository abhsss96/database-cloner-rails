namespace :database do
  desc "TODO"
  task upload: :environment do
    system("echo 'upload'")
    require "tasks/database_cloner/upload.rb"
  end

  desc "TODO"
  task download: :environment do
    require "tasks/database_cloner/download.rb"
  end

end
