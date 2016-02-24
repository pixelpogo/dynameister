describe Dynameister::Client do

  let(:client)           { Dynameister::Client.new }
  let(:table_name)       { "my-table" }
  let(:default_hash_key) { create_key :id }

  describe "#create_table" do

    let(:hash_key)         { create_key :my_hash_key }
    let(:capacity)         { 99 }
    let(:table_options) do
      {
        read_capacity:  capacity,
        write_capacity: capacity,
        range_key: create_key(:created_at)
      }
    end

    let(:table) do
      client.create_table(table_name: table_name,
                          hash_key:   hash_key,
                          options:    table_options)
    end

    after do
      table.delete
    end

    it "creates a new table" do
      expect(table.table_status).to eq("ACTIVE")
    end

    context "the tables throughput" do

      subject { table.provisioned_throughput }

      its(:read_capacity_units)  { is_expected.to eq(capacity) }
      its(:write_capacity_units) { is_expected.to eq(capacity) }

    end

    context "the tables attributes" do

      context "the hash key attribute" do

        subject { table.attribute_definitions[0] }

        its(:attribute_name) { is_expected.to eq(hash_key.name.to_s) }
        its(:attribute_type) { is_expected.to eq("S") }

      end

      context "the created_at attribute" do

        subject { table.attribute_definitions[1] }

        its(:attribute_name) { is_expected.to eq("created_at") }
        its(:attribute_type) { is_expected.to eq("S") }

      end

    end

    context "the tables key schema" do

      context "the hash key" do

        subject { table.key_schema[0] }

        its(:attribute_name) { is_expected.to eq(hash_key.name.to_s) }
        its(:key_type)       { is_expected.to eq("HASH") }

      end

      context "the range key" do

        subject { table.key_schema[1] }

        its(:attribute_name) { is_expected.to eq("created_at") }
        its(:key_type)       { is_expected.to eq("RANGE") }

      end

    end

  end

  describe "#delete_table" do

    subject { client.delete_table(table_name: table_name) }

    context "without a preexisting table" do

      it "returns false" do
        expect(subject).to eq(false)
      end

    end

    context "with a preexisting table" do

      before do
        client.create_table(table_name: table_name, hash_key: default_hash_key)
      end

      it "returns true" do
        expect(subject).to eq(true)
      end

      it "deletes the given table" do
        subject

        expect(client.aws_client.list_tables.table_names).to_not include(table_name)
      end

    end

  end

  describe "#get_item" do

    let(:item_hash_key) { { id: "123" } }
    let(:item)          { item_hash_key.merge(user: "john doe", skills: ["ruby", "html", "javascript"]) }
    let(:expected_item) { item.stringify_keys }

    let(:put_hash) { { table_name: table_name, item: item } }

    before do
      table

      client.aws_client.put_item(put_hash)
    end

    after do
      table.delete
    end

    context "for a hash key only table" do

      let(:table) { client.create_table(table_name: table_name, hash_key: default_hash_key) }

      it "retrieves the item" do
        expect(
          client.get_item(table_name: table_name, hash_key: item_hash_key).item
        ).to eq(expected_item)
      end

    end

    context "for a hash and range key table" do

      let(:table) do
        client.create_table(table_name: table_name,
                            hash_key: default_hash_key,
                            options: { range_key: create_key(user: :string) })
      end
      let(:item_range_key) { { user: "john doe" } }

      it "retrieves the item" do
        expect(
          client.get_item(table_name: table_name, hash_key: item_hash_key, range_key: item_range_key).item
        ).to eq(expected_item)
      end

    end

  end

  describe "#put_item" do

    let(:table)          { client.create_table(table_name: table_name, hash_key: default_hash_key) }
    let(:item)           { { id: "123", user: "john doe", skills: ["ruby", "html", "javascript"] } }
    let(:expected_item)  { item.stringify_keys }

    let(:get_hash) { { table_name: table_name, key: { id: "123" } } }

    before do
      table
    end

    after do
      table.delete
    end

    it "stores the item" do
      client.put_item(table_name: table_name, item: item)

      retrieved_item = client.aws_client.get_item(get_hash).item

      expect(retrieved_item).to eq(expected_item)
    end

  end

  describe "#scan_table" do
    subject { client.scan_table(options) }

    let(:options) do
      {
        table_name: table_name,
        index_name: "IndexName",
        attributes_to_get: ["AttributeName"],
        limit: 1
      }
    end

    before :each do
      allow(client.aws_client).to receive(:scan)
    end

    it "delegates to aws_client#scan" do
      subject
      expect(client.aws_client).to have_received(:scan).with(options)
    end
  end

  describe "#query_table" do
    subject { client.query_table(options) }

    let(:options) do
      {
        table_name: table_name,
        index_name: "IndexName",
        attributes_to_get: ["AttributeName"],
        limit: 1
      }
    end

    before :each do
      allow(client.aws_client).to receive(:query)
    end

    it "delegates to aws_client#query" do
      subject
      expect(client.aws_client).to have_received(:query).with(options)
    end
  end

  describe "#delete_item" do

    let(:item_hash_key) { { id: "123" } }
    let(:item)          { item_hash_key.merge(user: "john doe", skills: ["ruby", "html", "javascript"]) }

    let(:put_hash) { { table_name: table_name, item: item } }

    before :each do
      table

      client.aws_client.put_item(put_hash)
    end

    after :each do
      table.delete
    end

    context "for a hash key only table" do

      let(:table)    { client.create_table(table_name: table_name, hash_key: default_hash_key) }
      let(:get_hash) { { table_name: table_name, key: item_hash_key } }

      it "deletes the item" do
        client.delete_item(table_name: table_name, hash_key: item_hash_key)

        expect(
          client.aws_client.get_item(get_hash).item
        ).to be_nil
      end

    end

    context "for a hash and range key table" do

      let(:table) do
        client.create_table(table_name: table_name,
                            hash_key: default_hash_key,
                            options: { range_key: create_key(user: :string) })
      end
      let(:item_range_key) { { user: "john doe" } }

      let(:get_hash)  { { table_name: table_name, key: item_hash_key.merge(item_range_key) } }

      it "deletes the item" do
        client.delete_item(table_name: table_name, hash_key: item_hash_key, range_key: item_range_key)

        expect(
          client.aws_client.get_item(get_hash).item
        ).to be_nil
      end

    end

  end

  describe "#describe_table" do

    let(:table_name) { "my table" }

    subject { client.describe_table(table_name: table_name) }

    before do
      allow(client.aws_client).to receive(:describe_table).with(table_name: table_name)
    end

    it "delegates to aws_client#describe_table" do
      subject
      expect(client.aws_client).to have_received(:describe_table).with(table_name: table_name)
    end
  end

end
