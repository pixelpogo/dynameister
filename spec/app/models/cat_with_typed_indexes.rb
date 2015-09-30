class CatWithTypedIndexes

  include Dynameister::Document

  field :pet_food
  field :adopted_at, :datetime

  table name: "kittens_with_typed_indexes", hash_key: { name: :number }, range_key: :created_at

end
