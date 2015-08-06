class Cat
  include Dynameister::Document

  table hash_key: :name

  field :name
end
