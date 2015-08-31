require_relative "../app/models/language"

describe Dynameister::Collection do

  let(:items) do
    [
      { "some_hash" => "here" },
      { "another" => "response" }
    ]
  end

  let(:response) { double("response", items: items, count: 2) }

  describe "a deserialized aws query response" do

    subject { described_class.new.deserialize_response(response) }

    it "returns an instance of response" do
      expect(subject).to be_an_instance_of Dynameister::Collection::Response
    end

    it "stores the deserialized output in entities" do
      expect(subject.entities).to eq(
        [{ some_hash:  "here" }, { another: "response" }]
      )
    end

  end

end
