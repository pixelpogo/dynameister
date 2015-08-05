class Language
  include Dynameister::Document

  field :locale
  field :displayable, :boolean
  field :rank, :integer
end

