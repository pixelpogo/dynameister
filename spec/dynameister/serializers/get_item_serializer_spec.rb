require_relative "../../../lib/dynameister/serializers/get_item_serializer.rb"
require_relative "shared_examples_for_serializers.rb"

describe Dynameister::Serializers::GetItemSerializer do

  let(:table_name) { "my-table" }
  let(:hash_key)   { { id: 123 } }

  describe "#to_h" do

    let(:options) { { table_name: table_name, key: hash_key } }

    subject { described_class.new(options).to_h }

    it_behaves_like "a serializer that includes table name and hash key"

    context "with an additional range key given" do

      let(:range_key) { { user: "john doe" } }
      let(:options)   { { table_name: table_name, key: hash_key.merge(range_key) } }

      it_behaves_like "a serializer that includes table name and hash key"

      it "includes the range_key" do
        expect(subject[:key]).to include(range_key)
      end

    end

  end

end
