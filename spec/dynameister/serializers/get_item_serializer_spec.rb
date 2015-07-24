require_relative "../../../lib/dynameister/serializers/get_item_serializer.rb"

describe Dynameister::Serializers::GetItemSerializer do

  let(:table_name) { "my-table" }
  let(:hash_key)   { { id: 123 } }

  describe "#to_h" do

    subject { described_class.new(table_name: table_name, hash_key: hash_key).to_h }

    it "includes table_name" do
      expect(subject).to include(table_name: table_name)
    end

    it "includes the hash_key" do
      expect(subject).to include(key: hash_key)
    end

  end

end
