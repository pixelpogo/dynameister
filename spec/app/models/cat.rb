class Cat

  include Dynameister::Document

  field :pet_food
  field :adopted_at, :datetime
  field :created_at

  # local indexes can only be defined on tables with hash and range key
  table name: "kittens", hash_key: :name, range_key: :created_at

  local_index :adopted_at # projection: :all, :keys_only, [:attr1, :attr2]

  global_index [:pet_food, :adopted_at], projection: :all, throughput: [2, 3]

end
