require_relative "../app/models/language"

describe Dynameister::Collection do

  let(:items) do
    [
      { "some_hash" => "here" },
      { "another"   => "value" }
    ]
  end

  let(:serialized_entities) do
    [
      { some_hash: "here" },
      { another:   "value" }
    ]
  end

  let(:response) { double("response", items: items, count: 2) }

  describe "a deserialized aws query response" do

    subject { described_class.new.deserialize_response(response) }

    it "returns an instance of response" do
      expect(subject).to be_an_instance_of Dynameister::Collection::Response
    end

    it "stores the deserialized output in entities" do
      expect(subject.entities).to eq serialized_entities
    end

  end

  describe "with a previous response" do

    let(:previous_response) do
      Dynameister::Collection::Response.new.tap do |resp|
        resp.entities = [{ purple_pony: "something here" }]
        resp.count = 1
      end
    end

    subject! { described_class.new.deserialize_response(response, previous_response) }

    it "returns an instance of response" do
      expect(previous_response).to be_an_instance_of Dynameister::Collection::Response
    end

    it "adds to the previous response additional deserialized output" do
      expect(previous_response.entities).to eq(
        [{ purple_pony: "something here" }] + serialized_entities
      )
    end

    it "increments the number of entities" do
      expect(previous_response.count).to eq 3
    end

  end
end
