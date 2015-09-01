require_relative "shared_examples_for_data_types.rb"

describe Dynameister::DataTypes::DateTime do

  let(:datetime) { DateTime.now }
  let(:attribute) { datetime }

  subject { described_class.new }

  its(:type) { is_expected.to be(:datetime) }

  describe "#serialize" do
    it "converts DateTime value into a BigDecimal" do
      expect(subject.serialize(datetime)).to be_kind_of BigDecimal
    end
  end

  describe "#deserialize" do
    it "converts a BigDecimal value into a DateTime" do
      expect(subject.cast(datetime)).to be_kind_of DateTime
    end
  end

  it_behaves_like "a DataType that can serialize and deserialize values in both ways"

end
