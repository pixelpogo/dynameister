describe Dynameister do

  let(:capacity) { 99 }

  before :each do
    Dynameister.configure do |config|
      config.read_capacity  capacity
      config.write_capacity capacity
    end
  end

  subject { Dynameister }

  its(:read_capacity)  { is_expected.to eq(capacity) }
  its(:write_capacity) { is_expected.to eq(capacity) }

end
