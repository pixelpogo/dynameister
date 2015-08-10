class Cat
  include Dynameister::Document

  table hash_key: :name

  range :attack_strength

  # Field definitions go first
  field :pet_food

  local_index :attack_strength # projection: :all, :keys_only, [:attr1, :attr2]
  #global_index :pet_food, :attack_strength #throughput
end
