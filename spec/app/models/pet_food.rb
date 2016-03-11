class PetFood

  include Dynameister::Document

  field :valid_until, :datetime
  field :created_at,  :time
  field :deliver_at,  :time

  table hash_key: :valid_until,
        range_key: :created_at

  local_index :deliver_at

end
