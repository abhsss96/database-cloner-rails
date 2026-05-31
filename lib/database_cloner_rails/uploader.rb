module DatabaseClonerRails
  class Uploader
    def self.run
      new.run
    end

    def run
      ActiveRecord::Base.connection.tables.each do |table|
        next unless table.classify.safe_constantize.present?
        begin
          require "tasks/database_cloner/db_dump/#{table}"
        rescue LoadError, StandardError => e
          puts "Oops!! #{table} could not be uploaded."
        end
      end
    end
  end
end
