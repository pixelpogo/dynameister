describe Dynameister::DataTypes::Time do

  let(:time) { Time.now }

  subject { described_class.instance }

  its(:type) { is_expected.to be(:time) }

  describe "#serialize" do
    it "converts Time value into a String" do
      expect(subject.serialize(time)).to be_kind_of String
    end

    it "converts a deserialized time to same value as the initial serialized time object" do
      expect(subject.serialize(subject.deserialize(subject.serialize(time)))).to eq subject.serialize(time)
    end
  end

  describe "#deserialize" do
    it "converts a String value into a Time" do
      expect(subject.deserialize(time.as_json)).to be_kind_of Time
    end

    it "deserializes a serialized time correctly" do
      expect(subject.deserialize(subject.serialize(time)).to_i).to eq time.to_i
    end
  end

end
