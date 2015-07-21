describe Dynameister::Client do

  let(:client) { Dynameister::Client.new }

  describe "#create_table" do

    let(:table_name)    { "my-table" }
    let(:hash_key)      { :my_hash_key }
    let(:capacity)      { 99 }
    let(:table_options) do
      {
        read_capacity:  capacity,
        write_capacity: capacity,
        range_key: { created_at: :number }
      }
    end

    let(:table) do
      client.create_table(table_name: table_name,
                          hash_key:   hash_key,
                          options:    table_options)
    end

    after :each do
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

        its(:attribute_name) { is_expected.to eq(hash_key.to_s) }
        its(:attribute_type) { is_expected.to eq("S") }

      end

      context "the created_at attribute" do

        subject { table.attribute_definitions[1] }

        its(:attribute_name) { is_expected.to eq("created_at") }
        its(:attribute_type) { is_expected.to eq("N") }

      end

    end

    context "the tables key schema" do

      context "the hash key" do

        subject { table.key_schema[0] }

        its(:attribute_name) { is_expected.to eq(hash_key.to_s) }
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

    let(:table_name) { "my-table" }

    subject { client.delete_table(table_name: table_name) }

    context "without a preexisting table" do

      it "returns false" do
        expect(subject).to eq(false)
      end

    end

    context "with a preexisting table" do

      before :each do
        client.create_table(table_name: table_name)
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

end
