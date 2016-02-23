describe Dynameister do

  let(:capacity)    { 99 }
  let(:endpoint)    { 'foo.bar' }
  let(:region)      { 'dyna-west-1' }
  let(:credentials) { Aws::Credentials.new("access_key_id", "secret_access_key", "session_token") }

  before :each do
    Dynameister.configure do |config|
      config.read_capacity capacity
      config.write_capacity capacity
      config.endpoint endpoint
      config.region region
    end
  end

  subject { Dynameister }

  its(:read_capacity)  { is_expected.to eq(capacity) }
  its(:write_capacity) { is_expected.to eq(capacity) }
  its(:endpoint)       { is_expected.to eq(endpoint) }
  its(:region)         { is_expected.to eq(region) }
  its(:credentials)    { is_expected.to be_an(Aws::Credentials) }

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
