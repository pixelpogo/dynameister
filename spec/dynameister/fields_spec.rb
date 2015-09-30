require_relative "../app/models/language"
require_relative "../app/models/cat"
require_relative "../app/models/cat_with_typed_indexes"

describe Dynameister::Fields do

  describe "auto-generated accessors" do

    subject { Language.new }

    it { is_expected.to respond_to(:locale) }
    it { is_expected.to respond_to(:rank) }
    it { is_expected.to respond_to(:displayable) }

    it { is_expected.to respond_to(:rank=) }
    it { is_expected.to respond_to(:locale=) }
    it { is_expected.to respond_to(:displayable=) }

  end

  describe "class level attributes with type definition" do

    subject { Language }

    its(:attributes) do
      is_expected.to eq(
        id:          { type: :string },
        locale:      { type: :string },
        displayable: { type: :boolean },
        rank:        { type: :integer }
      )
    end

  end

  describe "updating a document" do

    before { Language.create_table }

    after { delete_table("languages") }

    let!(:language) { Language.create(locale: "grumpy_cat", rank: 42) }

    subject { language.update_attributes(locale: "my_locale", rank: 99) }

    its(:locale) { is_expected.to eq("my_locale") }
    its(:rank)   { is_expected.to eq(99) }

    it "persists the modified data" do
      item = Language.find_by(hash_key: { id: subject.id })
      expect(subject.attributes).to eq(item.attributes)
    end

  end

  describe "hash key" do

    context "defaults" do

      subject { Language.new(id: "my_hash_key") }

      it "has id as the default hash key" do
        expect(subject.hash_key).to eq "my_hash_key"
      end

    end

    shared_examples_for "a table's hash key" do

      let(:hash_key_schema) do
        table.key_schema.first
      end

      it "supports a custom hash key" do
        expect(subject.hash_key).to eq hash_key_value
      end

      it "adds the attribute name to the table key schema" do
        expect(hash_key_schema.attribute_name).to eq "name"
      end

      it "adds the hash key type to the table key schema" do
        expect(hash_key_schema.key_type).to eq "HASH"
      end

    end

    context "its name can be overriden" do

      let(:hash_key_value) { "neko atsume" }
      let!(:table) { Cat.create_table }

      after { delete_table("kittens") }

      subject { Cat.new(name: hash_key_value) }

      it_behaves_like "a table's hash key"

    end

    context "its type can be overriden" do

      let(:hash_key_value) { 10 }
      let!(:table) { CatWithTypedIndexes.create_table }

      let(:hash_key_type) do
        table.attribute_definitions.detect do |a|
          a.attribute_name == 'name'
        end.attribute_type
      end

      after { delete_table("kittens_with_typed_indexes") }

      subject { CatWithTypedIndexes.new(name: hash_key_value) }

      it_behaves_like "a table's hash key"

      it "sets the custom hash key type" do
        expect(hash_key_type).to eq('N')
      end

    end

  end

  describe "range key" do

    after { delete_table("kittens") }

    subject! do
      cats = Cat.create_table
      cats.key_schema.last
    end

    it "adds the attribute name to the table key schema" do
      expect(subject.attribute_name).to eq "created_at"
    end

    it "adds the range key type to the table key schema" do
      expect(subject.key_type).to eq "RANGE"
    end

  end
end
