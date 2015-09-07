describe Dynameister::DataTypes::DateTime do

  let(:datetime) { DateTime.now }

  subject { described_class.instance }

  its(:type) { is_expected.to be(:datetime) }

  describe "#serialize" do
    it "converts DateTime value into a String" do
      expect(subject.serialize(datetime)).to be_kind_of String
    end

    it "converts a deserialized DateTime to same value as the initial serialized DateTime object" do
      expect(subject.serialize(subject.deserialize(subject.serialize(datetime)))).to eq subject.serialize(datetime)
    end
  end

  describe "#deserialize" do
    it "converts a String value into a DateTime" do
      expect(subject.deserialize(datetime.as_json)).to be_kind_of DateTime
    end

    it "deserializes a serialized DateTime correctly" do
      expect(subject.deserialize(subject.serialize(datetime)).to_i).to eq datetime.to_i
    end
  end
end
