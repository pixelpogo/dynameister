class CompactDisc

  include Dynameister::Document

  field :name
  field :tracks, :integer
  field :price, :float
  field :release_date, :datetime
  field :produced_at, :time

end
