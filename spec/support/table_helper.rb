def delete_table(name)
  Dynameister::Client.new.delete_table table_name: name
end
