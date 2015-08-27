require_relative "../app/models/language"
require_relative "../app/models/cat"

describe Dynameister::Fields do

  before { Language.create_table }

  after do
    delete_table("languages")
    delete_table("kittens")
  end

  subject { Language.new }

  it { is_expected.to respond_to(:locale) }
  it { is_expected.to respond_to(:rank) }
  it { is_expected.to respond_to(:displayable) }

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

    context "can be overriden" do

      subject { Cat.new(name: "neko atsume") }

      let(:cats_table) { Cat.create_table }

      let(:hash_key_schema) do
        cats_table.key_schema.first
      end

      it "supports a custom hash key" do
        expect(subject.hash_key).to eq "neko atsume"
      end

      it "adds the attribute name to the table key schema" do
        expect(hash_key_schema.attribute_name).to eq "name"
      end

      it "adds the hash key type to the table key schema" do
        expect(hash_key_schema.key_type).to eq "HASH"
      end

    end
  end

  describe "range key" do

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
