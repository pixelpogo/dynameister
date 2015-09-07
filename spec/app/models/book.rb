class Book

  include Dynameister::Document

  field :name
  field :rank, :integer
  field :author_id, :integer
  field :created_at, :datetime

  table hash_key: :uuid, range_key: :rank

  local_index :author_id

end
