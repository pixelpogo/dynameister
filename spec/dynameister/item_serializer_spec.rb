require_relative "../../lib/dynameister/item_serializer.rb"
require_relative "../../lib/dynameister/attribute_value.rb"

describe Dynameister::ItemSerializer do

  let(:values) { [123, "john doe", ["ruby", "html", "javascript"]] }
  let(:item)   { { id: values[0], user: values[1], skills: values[2] } }

  describe "#put_item_hash" do

    subject { described_class.new(item).put_item_hash }

    it "has exactly the same keys" do
      expect(subject.keys).to eq(item.keys)
    end

    it "turns into a 'dynamo-style' hash" do
      expect_any_instance_of(Dynameister::AttributeValue).to receive(:marshal).with(values[0])
      expect_any_instance_of(Dynameister::AttributeValue).to receive(:marshal).with(values[1])
      expect_any_instance_of(Dynameister::AttributeValue).to receive(:marshal).with(values[2])

      subject
    end

  end

end
