module DatabaseClonerRails
  class Uploader
    def self.run(only: nil)
      new(only: only).run
    end

    def initialize(only: nil)
      @only = Array(only).map(&:to_s).reject(&:empty?)
    end

    def run
      tables = ActiveRecord::Base.connection.tables
      tables = tables.select { |t| @only.include?(t) } if @only.any?
      tables.each do |table|
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
