require_relative "../../app/models/cat.rb"

describe Dynameister::Indexes::Index do

  subject { described_class.new(Cat, [:name, :pet_food]) }

  it "forms a table name from the provided keys" do
    expect(subject.table_name).to eq "index_cat_names_and_pet_foods"
  end

  it "assigns itself hash keys" do
    expect(subject.hash_keys).to eq([:name, :pet_food])
  end

 it "saves a model to its index" do
   binding.pry
   true
 end

 xit "deletes a model from its index" do
 end

 xit 'updates a model by removing it from its previous index and adding it to its new one' do
 end

end

