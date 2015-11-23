describe Dynameister do

  let(:capacity) { 99 }
  let(:endpoint) { 'foo.bar' }

  before :each do
    Dynameister.configure do |config|
      config.read_capacity capacity
      config.write_capacity capacity
      config.endpoint endpoint
    end
  end

  subject { Dynameister }

  its(:read_capacity)  { is_expected.to eq(capacity) }
  its(:write_capacity) { is_expected.to eq(capacity) }
  its(:endpoint)       { is_expected.to eq(endpoint) }

  context "when configuration is set on different threads" do

    let(:thread_1_capacity) { 2 }
    let(:thread_2_capacity) { 9 }

    let(:thread_1) do
      Thread.new(thread_1_capacity) do |capacity|
        Dynameister.configure { |config| config.read_capacity capacity }

        Dynameister.read_capacity
      end
    end

    let(:thread_2) do
      Thread.new(thread_2_capacity) do |capacity|
        Dynameister.configure { |config| config.read_capacity capacity }

        Dynameister.read_capacity
      end
    end

    it "sets the proper configuration on thread 1" do
      expect(thread_1.value).to eq(thread_1_capacity)
    end

    it "sets the proper configuration on thread 2" do
      expect(thread_2.value).to eq(thread_2_capacity)
    end

  end

end
