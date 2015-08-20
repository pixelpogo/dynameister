require_relative "../app/models/language"

describe Dynameister::Finders do

  let(:table_name) { "languages" }

  before { Language.create_table }

  after  { delete_table table_name }

  describe "fetching a document" do

    let!(:language) { Language.create(locale: "grumpy_cat") }

    subject { Language.find_by(hash_key: { id: language.id }) }

    it "returns an instance of document" do
      expect(subject).to be_an_instance_of(Language)
    end

    it "finds a document for a given hash key and returns the data" do
      expect(subject.attributes).to eq(language.attributes)
    end

  end

  describe "retrieving all documents of a given model" do

    before do
      Language.create_table
      3.times { |n| Language.create(locale: "lang#{n}") }
    end

    subject { Language.all }

    it "finds all records" do
      expect(subject.count).to eq(3)
    end

    it "returns an array with all the records' data" do
      expect(subject.map(&:locale)).to match_array %w(lang0 lang1 lang2)
    end

    context "limit" do

      subject { Language.all(limit: 1) }

      it 'finds all records with limit' do
        expect(subject.count).to eq(1)
      end

      it "returns an array with limited data" do
        expect(subject.first).to be_an_instance_of Language
      end

    end

  end

end
