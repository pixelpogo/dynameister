require_relative "../../../lib/dynameister/serializers/put_item_serializer.rb"

describe Dynameister::Serializers::PutItemSerializer do

  let(:table_name) { "my-table" }
  let(:item)       { { id: 123, user: "john doe", skills: ["ruby", "html", "javascript"] } }

  describe "#to_h" do

    subject { described_class.new(table_name: table_name, item: item).to_h }

    it "includes table_name" do
      expect(subject).to include(table_name: table_name)
    end

    it "includes the item" do
      expect(subject).to include(item: item)
    end

  end

end
