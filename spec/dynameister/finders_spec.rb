require_relative "../app/models/language"

describe Dynameister::Finders do

  let(:table_name) { "languages"}

  let!(:language) { Language.create(locale: "grumpy_cat") }

  after do
    Dynameister::Client.new.delete_table table_name: table_name
  end

  context "fetching a document" do

    subject { Language.find_by(hash_key: { id: language.id }) }

    it "returns an instance of document" do
      expect(subject).to be_an_instance_of(Language)
    end

    it "finds a document for a given hash key and returns the data" do
      expect(subject.attributes).to eq(language.attributes)
    end

  end

end

