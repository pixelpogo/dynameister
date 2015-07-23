require_relative "../../lib/dynameister/item_serializer.rb"

describe Dynameister::ItemSerializer do

  let(:table_name) { "my-table" }
  let(:item)       { { id: 123, user: "john doe", skills: ["ruby", "html", "javascript"] } }

  describe "#put_item_hash" do

    subject { described_class.new(table_name: table_name, item: item).put_item_hash }

    it "includes table_name" do
      expect(subject).to include(table_name: table_name)
    end

    it "has exactly the same keys" do
      expect(subject).to include(item: item)
    end

  end

end
