class CatWithOverwrittenIndexTypes

  include Dynameister::Document

  field :name, :string
  field :pet_food
  field :adopted_at, :datetime
  field :created_at, :string

  table name: "kittens_with_overwritten_index_types",
        hash_key: { name: :number },
        range_key: { created_at: :binary }

end
