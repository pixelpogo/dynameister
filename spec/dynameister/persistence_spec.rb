require_relative "../app/models/language"
require_relative "../app/models/cat"

describe Dynameister::Persistence do

  let(:table_name) { "languages" }

  describe "defaults for model" do

    subject { Language }

    its(:table_name) { is_expected.to eq(table_name) }

  end

  describe "creating a table" do

    subject! { Language.create_table }

    after { delete_table table_name }

    it "creates the table for the object" do
      expect(Dynameister::Client.new.table_names).to include(table_name)
    end

    it "does not create an additional table if it already exists" do
      expect { Language.create_table }.not_to raise_exception
    end

    context "custom table name" do

      subject! { Cat.create_table }

      after { delete_table Cat.table_name }

      it "creates a table" do
        expect(Dynameister::Client.new.table_names).to include("kittens")
      end

    end
  end

  describe "table_exists?" do

    subject { Language.table_exists? }

    after { delete_table Language.table_name }

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

    after { delete_table Language.table_name }

    subject! { Language.create(locale: "JPN") }

    it "generates an uuid for the hash_key of the document" do
      expect(subject.id).not_to be_nil
    end

  end

  describe "deleting a document" do

    before { Language.create_table }

    after { delete_table Language.table_name }

    let!(:language) { Language.create(locale: "GER", displayable: true, rank: 42) }

    subject!        { language.delete }

    it "deletes the record of the language object" do
      expect(Language.find_by(hash_key: { id: language.id })).to be_nil
    end

  end

  describe "table schema" do

    before { Language.create_table }

    after { delete_table Language.table_name }

    subject { Language.schema }

    it "has a representation of its schema" do
      expect(subject).to be_an_instance_of Aws::DynamoDB::Types::TableDescription
    end

  end

  describe "key schema keys" do

    before { Language.create_table }

    after { delete_table Language.table_name }

    subject { Language.key_schema_keys }

    it "has a representation of its schema" do
      expect(subject).to eq [:id]
    end

  end

  describe "serialize_attribute" do

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

  describe "serialize_attributes" do

    let(:item) do
      { id: "8d629240-d319-41a9-b39e-9df1d376476e",
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

  describe "deserialize_attributes" do

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
