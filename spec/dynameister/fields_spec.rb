require_relative "../app/models/language"
require_relative "../app/models/cat"

describe Dynameister::Fields do

  before { Language.create_table }

  after do
    delete_table("languages")
    delete_table("cats")
  end

  subject { Language.new }

  it { is_expected.to respond_to(:locale) }
  it { is_expected.to respond_to(:rank) }
  it { is_expected.to respond_to(:displayable) }

  describe "class level attributes with type definition" do

    subject { Language }

    its(:attributes) do is_expected.to eq(
       {
         id:          { type: :string },
         locale:      { type: :string },
         displayable: { type: :boolean },
         rank:        { type: :integer }
       }
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

      before  { Cat.create_table }
      subject { Cat.new(name: "neko atsume") }

      it "supports a custom hash key" do
        expect(subject.hash_key).to eq "neko atsume"
      end

    end
  end

end

