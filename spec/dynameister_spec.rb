describe Dynameister do

  let(:capacity)    { 99 }
  let(:endpoint)    { 'foo.bar' }
  let(:region)      { 'dyna-west-1' }
  let(:credentials) { Aws::Credentials.new("access_key_id", "secret_access_key", "session_token") }

  before :each do
    Dynameister.configure do |config|
      config.read_capacity  = capacity
      config.write_capacity = capacity
      config.endpoint       = endpoint
      config.region         = region
    end
  end

  subject { Dynameister::Config }

  its(:read_capacity)  { is_expected.to eq(capacity) }
  its(:write_capacity) { is_expected.to eq(capacity) }
  its(:endpoint)       { is_expected.to eq(endpoint) }
  its(:region)         { is_expected.to eq(region) }
  its(:credentials)    { is_expected.to be_an(Aws::Credentials) }

end
