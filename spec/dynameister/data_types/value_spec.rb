describe Dynameister::DataTypes::Value do

  let(:datetime) { DateTime.now }
  subject { described_class.new }

  its(:type) { is_expected.to be_nil }

  it_behaves_like "a DataType that can serialize and deserialize values in both ways"

end
