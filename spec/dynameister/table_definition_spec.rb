require_relative "../../lib/dynameister/table_definition.rb"

describe Dynameister::TableDefinition do

  let(:table_name)      { "a_table_name" }
  let(:capacity)        { 99 }
  let(:hash_key)        { { my_hash_key:  :string } }
  let(:range_key)       { { my_range_key: :number } }
  let(:other_range_key) { { my_other_range_key: :string } }
  let(:local_indexes) do
    [
      { name: "my_index1", range_key: range_key, projection: :all },
      { name: "my_index2", range_key: other_range_key, projection: :keys_only }
    ]
  end
  let(:global_indexes) do
    [
      { name: "my_global_index1", hash_key: hash_key, range_key: range_key, projection: :all, throughput: [1,1] }
    ]
  end
  let(:options) do
    {
      hash_key: hash_key,
      range_key: range_key,
      read_capacity:  capacity,
      write_capacity: capacity,
      local_indexes: local_indexes,
      global_indexes: global_indexes
    }
  end
  let(:local_indexes_with_other_range_key) do
    [ { name: 'index3',  range_key: { my_attribute: :string }, projection: :all } ]
  end

  let(:definition) { described_class.new(table_name, options) }

  describe "#to_h" do

    let(:expected_attribute_definitions) do
      [
        {
          attribute_name: "my_hash_key",
          attribute_type: "S"
        },
        {
          attribute_name: "my_range_key",
          attribute_type: "N"
        },
        {
          attribute_name: "my_other_range_key", # added via a local index
          attribute_type: "S"
        }
      ]
    end

    let(:expected_key_schema) do
      [
        {
          attribute_name: "my_hash_key",
          key_type:       "HASH"
        },
        {
          attribute_name: "my_range_key",
          key_type:       "RANGE"
        }
      ]
    end

    let(:expected_local_secondary_indexes) do
      [
        {
          index_name: "my_index1",
          key_schema: [
            {
              attribute_name: "my_hash_key",
              key_type:       "HASH"
            },
            {
              attribute_name: "my_range_key",
              key_type:       "RANGE"
            }
          ],
          projection: {
            projection_type: "ALL",
            non_key_attributes: nil
          }
        },
        {
          index_name: "my_index2",
          key_schema: [
            {
              attribute_name: "my_hash_key",
              key_type:       "HASH"
            },
            {
              attribute_name: "my_other_range_key",
              key_type:       "RANGE"
            }
          ],
          projection: {
            projection_type: "KEYS_ONLY",
            non_key_attributes: nil
          }
        }
      ]
    end

    let(:expected_global_secondary_indexes) do
      [
        {
          index_name: "my_global_index1",
          key_schema: [
            {
              attribute_name: "my_hash_key",
              key_type:       "HASH"
            },
            {
              attribute_name: "my_range_key",
              key_type:       "RANGE"
            }
          ],
          projection: {
            projection_type: "ALL",
            non_key_attributes: nil
          },
          provisioned_throughput: {
            read_capacity_units: 1,
            write_capacity_units: 1
          }
        }
      ]
    end

    subject { definition.to_h }

    it "includes the table name" do
      expect(subject[:table_name]).to eq(table_name)
    end

    it "includes the write capacity units" do
      expect(subject[:provisioned_throughput][:write_capacity_units]).to eq(capacity)
    end

    it "includes the read capacity units" do
      expect(subject[:provisioned_throughput][:read_capacity_units]).to eq(capacity)
    end

    it "includes the attribute definitions" do
      expect(subject[:attribute_definitions]).to eq(expected_attribute_definitions)
    end

    it "includes the key schema" do
      expect(subject[:key_schema]).to eq(expected_key_schema)
    end

    it "includes the global secondary indexes" do
      expect(subject[:global_secondary_indexes]).to eq(expected_global_secondary_indexes)
    end

    context "when there are more than five global secondary indexes" do
      let(:global_indexes) do
        Array.new(6, { name: "my_index1", hash_key: hash_key, range_key: other_range_key, projection: :keys_only, throughput: [2,3] })
      end

      it "raises an ArgumentError" do
        expect { subject }.to raise_exception(ArgumentError)
      end
    end

    describe "Local Secondary Indexes" do
      it "includes the local secondary indexes" do
        expect(subject[:local_secondary_indexes]).to eq(expected_local_secondary_indexes)
      end

      context "when there are more than five local secondary indexes" do
        let(:local_indexes) do
          Array.new(6, { name: "my_index2", range_key: other_range_key, projection: :keys_only })
        end

        it "raises an ArgumentError" do
          expect { subject }.to raise_exception(ArgumentError)
        end
      end

      context "when projection is of type INCLUDE" do
        let(:included_attribute_keys) { [ :attribute1, :attribute2 ] }
        let(:local_indexes) do
          [
            { name: 'my_index1', range_key: range_key, projection: included_attribute_keys },
          ]
        end
        let(:expected_local_secondary_indexes) do
          [
            {
              index_name: 'my_index1',
              key_schema: [
                {
                  attribute_name: 'my_hash_key',
                  key_type:       'HASH'
                },
                {
                  attribute_name: 'my_range_key',
                  key_type:       'RANGE'
                }
              ],
              projection: {
                projection_type: "INCLUDE",
                non_key_attributes: included_attribute_keys.map(&:to_s)
              }
            }
          ]
        end

        it "provides additional attributes for the projection" do
          expect(subject[:local_secondary_indexes]).to eq(expected_local_secondary_indexes)
        end
      end

      context "when local secondary indexes use a different range key" do
        let(:options) do
          {
            hash_key: hash_key,
            range_key: range_key,
            read_capacity:  capacity,
            write_capacity: capacity,
            local_indexes: local_indexes_with_other_range_key,
            global_indexes: global_indexes
          }
        end

        let(:expected_other_range_key) do
          {
            attribute_name: "my_attribute",
            attribute_type: "S"
          }
        end

        it "includes them in the attributes definitions" do
          expect(subject[:attribute_definitions]).to include(expected_other_range_key)
        end
      end

      context "hash key and range keys not used in table definitions but for indexes" do

        let(:global_indexes_with_other_hash_and_range_keys) do
          [
            {
              name:       'global_index',
              hash_key:   { hash_key_for_global_index:  :string },
              range_key:  { range_key_for_index: :number },
              projection: :all,
              throughput: [1,1]
            }
          ]
        end

        let(:local_indexes_with_duplicate_range_key) do
          [ { name: 'index3',  range_key: { range_key_for_index: :number }, projection: :all } ]
        end

        let(:options) do
          {
            hash_key:       hash_key,
            range_key:      range_key,
            read_capacity:  capacity,
            write_capacity: capacity,
            local_indexes:  local_indexes_with_duplicate_range_key,
            global_indexes: global_indexes_with_other_hash_and_range_keys
          }
        end

        let(:expected_other_hash_key) do
          {
            attribute_name: "hash_key_for_global_index",
            attribute_type: "S"
          }
        end

        let(:expected_other_range_key) do
          {
            attribute_name: "range_key_for_index",
            attribute_type: "N"
          }
        end


        it "adds the hash_key to the attribute definitions" do
          expect(subject[:attribute_definitions]).to include(expected_other_hash_key)
        end

        it "adds the range_key to the attribute definitions" do
          expect(subject[:attribute_definitions]).to include(expected_other_range_key)
        end

        it "does not add duplicate entries to the attribute definitions" do
          expect(
            subject[:attribute_definitions]
          ).to contain_exactly(
            {
              attribute_name: "my_hash_key",
              attribute_type: "S"
            },
            {
              attribute_name: "my_range_key",
              attribute_type: "N"
            },
            expected_other_hash_key,
            expected_other_range_key
          )

        end

      end
    end
  end

end

