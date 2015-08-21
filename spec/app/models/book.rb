class Book
  include Dynameister::Document

  field :name
  field :rank, :number
  field :author_id, :number

  table hash_key: :uuid, range_key: :rank

  local_index :author_id
end
