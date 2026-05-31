#ActiveRecord::Base.connection.tables.map{|x|x.classify.safe_constantize}.compact
ActiveRecord::Base.connection.tables.map do |i|
  if i.classify.safe_constantize.present?
    model_obj = i.classify.safe_constantize
    all_records = model_obj.all.order(:id)
    file_path = "#{Rails.root}/lib/tasks/database_cloner/db_dump/#{i}.rb"
    data = []
    all_records.each do |task|
      puts task
      hash = JSON.parse(task.to_json).to_hash
      hash.delete("created_at")
      hash.delete("updated_at")
      hash.delete("id")
      temp = "#{model_obj.to_s}.create(#{hash})"
      puts temp
      data.push(temp)
      data.push('puts "uploading ...."')
      data.push("puts ' ***===========>#{i}=====*** '")
    end
    File.new(file_path,'w+')  
    File.open(file_path, 'w') do |f2|  
      f2.puts data 
    end
  end
end


