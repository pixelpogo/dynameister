require_relative "../../../lib/dynameister/serializers/get_item_serializer.rb"

describe Dynameister::Serializers::GetItemSerializer do

  shared_examples_for "a serializer that includes table name and hash key" do

    it "includes table_name" do
      expect(subject).to include(table_name: table_name)
    end

    it "includes the hash_key" do
      expect(subject[:key]).to include(hash_key)
    end

  end

  let(:table_name) { "my-table" }
  let(:hash_key)   { { id: 123 } }

  describe "#to_h" do

    let(:options) { { table_name: table_name, hash_key: hash_key } }

    subject { described_class.new(options).to_h }

    it_behaves_like "a serializer that includes table name and hash key"

    context "with an additional range key given" do

      let(:range_key) { { user: "john doe" } }
      let(:options)   { { table_name: table_name, hash_key: hash_key, range_key: range_key } }

      it_behaves_like "a serializer that includes table name and hash key"

      it "includes the range_key" do
        expect(subject[:key]).to include(range_key)
      end

    end

  end

end
