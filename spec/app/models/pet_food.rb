class PetFood

  include Dynameister::Document

  field :valid_until, :datetime
  field :created_at,  :time

  table hash_key: :valid_until,
        range_key: :created_at

end
