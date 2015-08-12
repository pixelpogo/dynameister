class Cat
  include Dynameister::Document

  # Field definitions go first
  field :pet_food
  field :adopted_at, :datetime

  table hash_key: :name, range_key: :adopted_at

  local_index :adopted_at # projection: :all, :keys_only, [:attr1, :attr2]
end
