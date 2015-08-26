require_relative "../app/models/language"

describe Dynameister::Collection do

  let(:client)     { Language.client }

  let(:table_name) { "languages" }

  subject { described_class.new(client, table_name ) }

  let(:response) { double("response", items: []) }

  before do
    allow(subject).to receive(:key_schema_keys).and_return [:id]
    allow(client).to receive(:query_table).with({table_name: table_name}).and_return response
    allow(client).to receive(:scan_table).with({table_name: table_name}).and_return response
  end

  it "has a key schema" do
    expect(subject.key_schema_keys).to eq [:id]
  end

  describe "#scan" do

    it "takes an aws dynamodb response and deserializes" do
      expect(subject).to receive(:deserialize_response).with(response, nil)
      subject.scan({})
    end

  end

  describe "#query" do

    it "takes an aws dynamodb response and deserializes" do
      expect(subject).to receive(:deserialize_response).with(response, nil)
      subject.query({})
    end

  end

end
