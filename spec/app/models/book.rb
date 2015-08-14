class Book
  include Dynameister::Document

  field :name
  field :rank, :number

  table hash_key: :uuid, range_key: :rank
end
