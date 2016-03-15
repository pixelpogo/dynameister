require_relative "../app/models/language"
require_relative "../app/models/cat"
require_relative "../app/models/pet_food_with_callback"
require_relative "../app/models/book"

describe Dynameister::Persistence do

  let(:table_name) { "languages" }

  describe "defaults for model" do

    subject { Language }

    its(:table_name) { is_expected.to eq(table_name) }

  end

  describe "creating a table" do

    subject! { Language.create_table }

    after { Language.delete_table }

    it "creates the table for the object" do
      expect(Dynameister::Client.new.table_names).to include(table_name)
    end

    it "does not create an additional table if it already exists" do
      expect { Language.create_table }.not_to raise_exception
    end

    context "with a custom table name" do

      subject! { Cat.create_table }

      after { Cat.delete_table }

      it "creates a table" do
        expect(Dynameister::Client.new.table_names).to include("kittens")
      end

    end
  end

  describe "deleting a table" do

    context "with a default table name" do

      before { Language.create_table }

      subject { Language.delete_table }

      let(:table_name) { "languages" }

      it "deletes the table" do
        subject
        expect(Dynameister::Client.new.table_names).to_not include(table_name)
      end

    end

    context "with a custom table name" do

      before { Cat.create_table }

      subject { Cat.delete_table }

      let(:table_name) { "kittens" }

      it "deletes the table" do
        subject
        expect(Dynameister::Client.new.table_names).to_not include(table_name)
      end

    end

  end

  describe "table_exists?" do

    subject { Language.table_exists? }

    after { Language.delete_table }

    it "returns false if table does not exist" do
      expect(subject).to be false
    end

    it "returns true if table exists" do
      Language.create_table
      expect(subject).to be true
    end
  end

  describe "creating a document" do

    before { Language.create_table }

    after { Language.delete_table }

    subject { Language.new(locale: "de", rank: 42) }

    its(:locale) { is_expected.to eq("de") }
    its(:rank)   { is_expected.to eq(42) }

    it "does not persist the data" do
      expect { subject }.to_not change {
        Language.all.count
      }
    end

  end

  describe "creating a table" do

    before { Language.create_table }

    after { Language.delete_table }

    subject { Language.create(locale: "de", rank: 42) }

    it "generates a uuid for the key of the document" do
      expect(subject.id).not_to be_nil
    end

    it "persists the data" do
      item = Language.find_by(key: { id: subject.id })
      expect(subject.attributes).to eq(item.attributes)
    end

  end

  describe "saving a document" do

    before { Language.create_table }

    after { Language.delete_table }

    let(:document) { Language.new(locale: "de", rank: 42) }

    subject { document.save }

    it "generates a uuid for the key of the document" do
      expect(subject.id).not_to be_nil
    end

    it "persists the data" do
      item = Language.find_by(key: { id: subject.id })
      expect(subject.attributes).to eq(item.attributes)
    end

    context "with a before_save callback" do

      before { PetFoodWithCallback.create_table }

      after { PetFoodWithCallback.delete_table }

      context "when the callback succeeds" do

        let(:document) { PetFoodWithCallback.new }

        it "executes the callback" do
          expect(subject.valid_until).not_to be_nil
        end

        it "persists the data" do
          item = PetFoodWithCallback.find_by(key: { id: subject.id })
          expect(subject.attributes).to eq(item.attributes)
        end

      end

      context "when the callback fails" do

        let(:document) { PetFoodWithCallback.new(valid_until: Time.now - 3.months) }

        it "returns false" do
          expect(subject).to be(false)
        end

        it "does not persist the data" do
          expect { subject }.to_not change {
            PetFoodWithCallback.all.count
          }
        end

      end

    end

  end

  describe "updating attributes" do

    before { Language.create_table }

    after { Language.delete_table }

    let(:language) { Language.create(locale: "de", rank: 42) }

    subject { language.update_attributes(locale: "my_locale", rank: 99) }

    its(:locale) { is_expected.to eq("my_locale") }
    its(:rank)   { is_expected.to eq(99) }

    it "persists the modified data" do
      item = Language.find_by(key: { id: subject.id })
      expect(subject.attributes).to eq(item.attributes)
    end

  end

  describe "deleting a document" do

    context "the primary key consists of only a hash key" do

      before { Language.create_table }

      after { Language.delete_table }

      let!(:language) { Language.create(locale: "GER", displayable: true, rank: 42) }

      subject! { language.delete }

      it "deletes the record of the language object" do
        expect(Language.find_by(key: { id: language.id })).to be_nil
      end

    end

    context "the primary key consists of composite keys" do

      before { Book.create_table }

      after { Book.delete_table }

      let!(:book) { Book.create(uuid: "id", rank: 42, author_id: 1) }

      subject! { book.delete }

      it "deletes the book record" do
        expect(Book.query(uuid: "id").and(rank: 42).all).to eq []
      end

    end
  end

  describe "schema" do

    before { Language.create_table }

    after { Language.delete_table }

    subject { Language.schema }

    it "has a representation of its schema" do
      expect(subject).to be_an_instance_of Aws::DynamoDB::Types::TableDescription
    end

  end

  describe "key schema keys" do

    before { Language.create_table }

    after { Language.delete_table }

    subject { Language.key_schema_keys }

    it "has a representation of its schema" do
      expect(subject).to eq [:id]
    end

  end

  describe "serialize an attribute" do

    subject { Cat.serialize_attribute(attr_hash) }

    context "Dynameister convenience DataType handling" do
      let(:attr_hash) { { adopted_at: DateTime.now } }
      it "converts attribute value of non-default DataTypes, e.g. a DateTime attribute from DateTime into String" do
        expect { subject }.to change { attr_hash[:adopted_at].class }.from(DateTime).to(String)
      end
    end

    context "default DataType handling" do
      let(:attr_hash) { { pet_food: "Meat" } }
      it "does not change attribute value of default DataType, e.g. a String attribute" do
        expect { subject }.not_to change { attr_hash[:adopted_at].class }
      end
    end
  end

  describe "serializing attributes" do

    let(:item) do
      {
        id: "8d629240-d319-41a9-b39e-9df1d376476e",
        name: "Garfield",
        adopted_at: DateTime.now,
        pet_food: "Meat"
      }
    end

    subject { Cat.serialize_attributes(item) }

    it "calls serialize_attribute method for each attribute" do
      expect(Cat).to receive(:serialize_attribute).exactly(4).times.with(kind_of(Hash)).and_call_original
      subject
    end
  end

  describe "deserialize attributes" do

    let(:raw_attributes) do
      { name: "Garfield",
        adopted_at: "1987-06-01T00:00:00.000+00:00" }
    end

    subject { Cat.deserialize_attributes(raw_attributes) }

    it "converts attribute value of non-default DataTypes, e.g. a DateTime attribute from String into DateTime" do
      expect(subject[:adopted_at]).to be_kind_of DateTime
    end

    it "does not change attribute value of default DataType, e.g. a String attribute" do
      expect(subject[:name]).to be_kind_of String
    end

  end

end
