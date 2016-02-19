require_relative "../app/models/language"

describe Dynameister::Finders do

  let(:table_name) { "languages" }

  before { Language.create_table }

  after  { Language.delete_table }

  describe "fetching a document" do

    context "there is a language" do

      let!(:language) { Language.create(locale: "grumpy_cat") }

      subject { Language.find_by(hash_key: { id: language.id }) }

      it "returns an instance of document" do
        expect(subject).to be_an_instance_of(Language)
      end

      it "finds a document for a given hash key and returns the data" do
        expect(subject.attributes).to eq(language.attributes)
      end

    end

    context "no language found for the given hash key" do

      subject { Language.find_by(hash_key: { id: "nothing here" }) }

      it "finds a document for a given hash key and returns the data" do
        expect(subject).to be_nil
      end

    end

  end

  describe "retrieving all documents of a given model" do

    before do
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

  describe "find" do

    3.times do |index|
      let("lang#{index}") { Language.create }
    end

    context "with a single hash_key" do

      subject { Language.find(lang0.id) }

      it "returns the language with the corresponding hash_key" do
        expect(subject.id).to eq lang0.id
      end

      it "returns an instance of language" do
        expect(subject).to be_an_instance_of Language
      end

    end

    context "with an array of hash_keys" do

      subject { Language.find lang0.id, lang2.id }

      it "returns the languages with the corresponding hash_keys" do
        expect(subject.map(&:id)).to match_array [lang0.id, lang2.id]
      end

    end

    context "nothing found" do

      it "with a single hash_key returns nil" do
        expect(Language.find("some id")).to be_nil
      end

      it "with multiple hash_keys returns an empty array" do
        expect(Language.find("some id", "another_id here")).to be_empty
      end

    end

  end

end
