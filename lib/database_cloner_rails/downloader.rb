require "fileutils"
require "json"

module DatabaseClonerRails
  class Downloader
    def self.run(dump_dir: default_dump_dir, only: nil)
      new(dump_dir: dump_dir, only: only).run
    end

    def self.default_dump_dir
      File.join(Rails.root, "lib", "tasks", "database_cloner", "db_dump")
    end

    def initialize(dump_dir: self.class.default_dump_dir, only: nil)
      @dump_dir = dump_dir
      @only     = Array(only).map(&:to_s).reject(&:empty?)
    end

    def run
      FileUtils.mkdir_p(@dump_dir)
      tables = ActiveRecord::Base.connection.tables
      tables = tables.select { |t| @only.include?(t) } if @only.any?
      tables.each do |table|
        model = table.classify.safe_constantize
        next unless model.present?
        dump_table(table, model)
      end
    end

    private

    def dump_table(table, model)
      lines = []
      model.all.order(:id).each do |record|
        puts record
        attrs = JSON.parse(record.to_json)
        attrs.delete("created_at")
        attrs.delete("updated_at")
        attrs.delete("id")
        lines << "#{model}.create(#{attrs})"
        lines << 'puts "uploading ...."'
        lines << "puts ' ***===========>#{table}=====*** '"
      end
      File.open(File.join(@dump_dir, "#{table}.rb"), "w") { |f| f.puts lines }
    end
  end
end
