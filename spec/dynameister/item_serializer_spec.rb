require_relative "../../lib/dynameister/item_serializer.rb"
require_relative "../../lib/dynameister/attribute_value.rb"

describe Dynameister::ItemSerializer do


  describe "#put_item_hash" do



    let(:item) { {id: 123, user: "john doe", skills: ["ruby", "html", "javascript"]} }
    subject { described_class.new(item).put_item_hash }

    it "has exactly the same keys" do
      expect(subject.keys).to eq(item.keys)
    end

    # @item.keys.each do |key|
    #   it "turns #{@item[key]} into 'dynamo-style' hashes" do
    #     expect_any_instance_of(Dynameister::AttributeValue).to receive(:marshal).with(@item[key])
    #     subject
    #   end
    # end

  end



end
