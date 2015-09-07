require_relative "shared_examples_for_data_types.rb"

describe Dynameister::DataTypes::Integer do

  let(:integer) { 3 }
  let(:attribute) { integer }

  subject { described_class.instance }

  its(:type) { is_expected.to be(:integer) }

  describe "#deserialize" do
    it "converts a BigDecimal value into an Integer" do
      expect(subject.deserialize(BigDecimal.new(integer.to_s))).to be_kind_of Integer
    end
  end

  it_behaves_like "a DataType that can serialize and deserialize values in both ways"

end
