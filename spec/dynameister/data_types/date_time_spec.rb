require_relative "shared_examples_for_data_types.rb"

describe Dynameister::DataTypes::DateTime do

  let(:datetime) { DateTime.now }
  let(:attribute) { datetime }

  subject { described_class.instance }

  its(:type) { is_expected.to be(:datetime) }

  it_behaves_like "a DataType that can serialize and deserialize values in both ways"

  describe "#serialize" do
    it "converts DateTime value into a String" do
      expect(subject.serialize(datetime)).to be_kind_of String
    end
  end

end
