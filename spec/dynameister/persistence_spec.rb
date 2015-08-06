require_relative "../app/models/language"

describe Dynameister::Persistence do

  let(:table_name) { "languages"}

  after do
    Dynameister::Client.new.delete_table table_name: table_name
  end

  describe "defaults for model" do

    subject { Language }

    its(:table_name) { is_expected.to eq(table_name) }

  end

  describe "creating a table" do

    subject! { Language.create_table }

    it "creates the table for the object" do
      expect(Dynameister::Client.new.table_names).to include(table_name)
    end

    it "does not create an additional table if it already exists" do
      expect{ Language.create_table }.not_to raise_exception
    end

  end

  describe "creating a document" do

    before { Language.create_table }

    subject! { Language.create(locale: "JPN") }

    it "generates an uuid for the hash_key of the document" do
      expect(subject.id).not_to be_nil
    end

  end


  describe "deleting a document" do

    before { Language.create_table }

    let!(:language) { Language.create(locale: "GER", displayable: true, rank: 42) }

    subject!        { language.delete }

    it "deletes the record of the language object" do
      expect(Language.find_by(hash_key: { id: language.id })).to be_nil
    end

  end

end
