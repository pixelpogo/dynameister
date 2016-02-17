require_relative "../app/models/language"
require_relative "../app/models/cat"
require_relative "../app/models/cat_with_typed_primary_key"
require_relative "../app/models/cat_with_overwritten_primary_key_data_types"
require_relative "../app/models/range_key_accessors"
require_relative "../app/models/compact_disc"

describe Dynameister::Fields do

  shared_examples_for "a table's hash key" do

    let(:hash_key_schema) do
      table.key_schema.first
    end

    it "supports a custom hash key" do
      expect(subject.hash_key).to eq hash_key_value
    end

    it "adds the attribute name to the table key schema" do
      expect(hash_key_schema.attribute_name).to eq hash_key_name
    end

    it "adds the hash key type to the table key schema" do
      expect(hash_key_schema.key_type).to eq "HASH"
    end

  end

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

    after { delete_table(Language.table_name) }

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

    context "its name can be overriden" do

      let(:hash_key_value) { "neko atsume" }
      let!(:table)         { Cat.create_table }
      let(:hash_key_name)  { "name" }

      after { delete_table(Cat.table_name) }

      subject { Cat.new(name: hash_key_value) }

      it_behaves_like "a table's hash key"

    end

    context "its type can be overriden" do

      let(:hash_key_value) { 10 }
      let!(:table)         { CatWithTypedPrimaryKey.create_table }
      let(:hash_key_name)  { "name" }

      let(:hash_key_type) do
        table.attribute_definitions.detect do |a|
          a.attribute_name == hash_key_name
        end.attribute_type
      end

      after { delete_table(CatWithTypedPrimaryKey.table_name) }

      subject { CatWithTypedPrimaryKey.new(name: hash_key_value) }

      it_behaves_like "a table's hash key"

      it "sets the custom hash key type" do
        expect(hash_key_type).to eq("N")
      end

    end

    context "its data_type can be derived from the field definition" do

      let!(:table)         { CompactDisc.create_table }
      let(:hash_key_name)  { "produced_at" }
      let(:hash_key_value) { Time.now }

      let(:hash_key_type) do
        table.attribute_definitions.detect do |a|
          a.attribute_name == "produced_at"
        end.attribute_type
      end

      subject { CompactDisc.new(produced_at: hash_key_value) }

      after { delete_table(CompactDisc.table_name) }

      it_behaves_like "a table's hash key"

      it "field with a custom data type" do
        expect(hash_key_type).to eq("S")
      end

    end

    context "its attribute accessors" do

      let(:hash_key_value) { "a name" }
      let!(:table)         { Cat.create_table }

      after { delete_table(Cat.table_name) }

      subject { Cat.new(name: hash_key_value) }

      it "a getter is being generated" do
        expect(subject.name).to eq hash_key_value
      end

      it "a setter is being generated" do
        expect {
          subject.name = "name"
        }.to change { subject.name }.from(hash_key_value).to("name")
      end

    end

  end

  describe "range key" do

    let(:range_key_schema) { table.key_schema.last }

    context "with default type" do

      let!(:table) { Cat.create_table }

      after { delete_table(Cat.table_name) }

      subject { Cat.new(name: "name", created_at: "today") }

      it "supports defining a range key" do
        expect(subject.range_key).to eq "today"
      end

      it "adds the attribute name to the table key schema" do
        expect(range_key_schema.attribute_name).to eq "created_at"
      end

      it "adds the range key type to the table key schema" do
        expect(range_key_schema.key_type).to eq "RANGE"
      end

    end

    context "its default type can be overriden" do

      let!(:table) { CatWithTypedPrimaryKey.create_table }

      let(:range_key_type) do
        table.attribute_definitions.detect do |a|
          a.attribute_name == "created_at"
        end.attribute_type
      end

      after { delete_table(CatWithTypedPrimaryKey.table_name) }

      subject { CatWithTypedPrimaryKey.new(name: "name", created_at: "today") }

      it "supports defining a range key" do
        expect(subject.range_key).to eq "today"
      end

      it "adds the attribute name to the table key schema" do
        expect(range_key_schema.attribute_name).to eq "created_at"
      end

      it "adds the range key type to the table key schema" do
        expect(range_key_schema.key_type).to eq "RANGE"
      end

      it "sets the custom range key type" do
        expect(range_key_type).to eq("B")
      end

    end

    context "derives its data type from the field definitions if given" do

      let!(:table) { CompactDisc.create_table }

      let(:range_key_type) do
        table.attribute_definitions.detect do |a|
          a.attribute_name == "release_date"
        end.attribute_type
      end

      after { delete_table(CompactDisc.table_name) }

      subject do
        CompactDisc.new(produced_at: Time.now, release_date: DateTime.tomorrow)
      end

      it "sets the range key data type to string" do
        expect(range_key_type).to eq("S")
      end

    end

    context "its attribute accessors" do

      let!(:table) { RangeKeyAccessors.create_table }

      after { delete_table(RangeKeyAccessors.table_name) }

      subject { RangeKeyAccessors.new(created_at: 1234) }

      it "a getter is being generated" do
        expect(subject.created_at).to eq 1234
      end

      it "a setter is being generated" do
        expect {
          subject.created_at = 4321
        }.to change { subject.created_at }.from(1234).to(4321)
      end

    end

  end

  describe "overwritten index types" do

    let(:hash_key_value) { 123 }
    let(:hash_key_name)  { "name" }

    let!(:table) do
      CatWithOverwrittenPrimaryKeyDataTypes.create_table
    end

    let(:hash_key_type) do
      table.attribute_definitions.detect do |a|
        a.attribute_name == "name"
      end.attribute_type
    end

    let(:range_key_type) do
      table.attribute_definitions.detect do |a|
        a.attribute_name == "created_at"
      end.attribute_type
    end

    let(:expected_model_attributes) do
      {
        name:       { type: :number },
        pet_food:   { type: :string },
        adopted_at: { type: :datetime },
        created_at: { type: :binary }
      }
    end

    after { delete_table(CatWithOverwrittenPrimaryKeyDataTypes.table_name) }

    subject { CatWithOverwrittenPrimaryKeyDataTypes.new(name: hash_key_value) }

    it_behaves_like "a table's hash key"

    it "overwrites the hash key type defined in the field definition" do
      expect(hash_key_type).to eq("N")
    end

    it "overwrites the range key type defined in the field definition" do
      expect(range_key_type).to eq("B")
    end

    it "has the proper overwritten hash and range key types" do
      expect(
        CatWithOverwrittenPrimaryKeyDataTypes.attributes
      ).to eq expected_model_attributes
    end

  end

end
