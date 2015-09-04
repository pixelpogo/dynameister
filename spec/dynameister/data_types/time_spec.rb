require_relative "shared_examples_for_data_types.rb"

describe Dynameister::DataTypes::Time do

  let(:time) { Time.now }
  let(:attribute) { time }

  subject { described_class.instance }

  its(:type) { is_expected.to be(:time) }

  describe "#serialize" do
    it "converts Time value into a String" do
      expect(subject.serialize(time)).to be_kind_of String
    end
  end

  describe "#deserialize" do
    it "converts a Rational value into a Time" do
      expect(subject.deserialize(time.to_r)).to be_kind_of Time
    end
  end

  it_behaves_like "a DataType that can serialize and deserialize values in both ways"

end
