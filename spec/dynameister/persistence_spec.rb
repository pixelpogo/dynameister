require_relative "../app/models/language"

describe Dynameister::Persistence do

  let(:table_name) { "languages"}

  after do
    Dynameister::Client.new.delete_table table_name: table_name
  end

  context "defaults for model" do

    subject { Language }

    its(:table_name) { is_expected.to eq(table_name) }

  end

  context "creating a document" do

    subject! { Language.create(locale: "JPN") }

    it "creates the table for the object" do
      expect(Dynameister::Client.new.table_names).to include(table_name)
    end

    it "does not create an additional table if it already exists" do
      expect{ subject.save }.not_to raise_exception
    end

    it "generates an uuid for the hash_key of the document" do
      expect(subject.id).not_to be_nil
    end

  end


  context "deleting a document" do

    let!(:language) { Language.create(locale: "GER", displayable: true, rank: 42) }

    subject!        { language.delete }

    it "deletes the record of the language object" do
      expect(Language.find_by(hash_key: { id: language.id })).to be_nil
    end

  end

end
