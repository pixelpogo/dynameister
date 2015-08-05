require_relative "../app/models/language"

describe Dynameister::Document do

  let(:table_name) { "languages"}

  after do
    Dynameister::Client.new.delete_table table_name: table_name
  end

  subject { Language.new(locale: "GER", displayable: true, rank: 42) }

  its(:locale) { is_expected.to eq("GER") }
  its(:displayable) { is_expected.to eq(true) }
  its(:rank) { is_expected.to eq(42) }

  context "defaults for model" do

    subject { Language }

    its(:table_name) { is_expected.to eq(table_name) }

  end

  context "object initialization" do

    before { subject.save }

    it "creates the table for the object" do
      expect(Dynameister::Client.new.table_names).to include(table_name)
    end

    it "does not create an additional table if it already exists" do
      expect{ subject.save }.not_to raise_exception
    end

  end

  describe "crud for a document" do

    let!(:language) { Language.create(locale: "GB_UK", rank: 42 ) }

    context "creating a document" do

      it "generates an uuid for the hash_key of the document" do
        expect(language.id).not_to be_nil
      end

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

    context "updating a document" do

      subject { language.update_attributes(locale: "my_locale", rank: 99) }

      its(:locale) { is_expected.to eq("my_locale") }
      its(:rank)   { is_expected.to eq(99) }

      it "persists the modified data" do
        item = Language.find_by(hash_key: { id: subject.id })
        expect(subject.attributes).to eq(item.attributes)
      end

    end

    context "deleting a document" do

      subject! { language.delete }

      it "deletes the record of the language object" do
        expect(Language.find_by(hash_key: { id: language.id })).to be_nil
      end

    end

  end

end
