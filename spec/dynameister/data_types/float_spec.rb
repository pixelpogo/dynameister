require 'spec_helper'

describe Dynameister::DataTypes::Float do

  let(:float) { 23.42 }
  let(:attribute) { float }

  subject { described_class.instance }

  its(:type) { is_expected.to be(:float) }

  it_behaves_like "a DataType that can serialize and deserialize values in both ways"

end
