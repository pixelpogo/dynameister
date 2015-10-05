def create_hash_key(key_name)
  Dynameister::Key.build_hash_key(key_name)
end

def create_range_key(key_name)
  Dynameister::Key.build_range_key(key_name)
end
