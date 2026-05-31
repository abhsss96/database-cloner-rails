ActiveRecord::Base.connection.tables.map do |i|
  begin
    if i.classify.safe_constantize.present?
      require "tasks/database_cloner/db_dump/#{i}.rb"
    end

  rescue  
    puts "Oops!! #{i} could not be uploaded."
  end
end
