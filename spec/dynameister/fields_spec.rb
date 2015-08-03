require_relative "../app/models/language"

describe Dynameister::Fields do


  subject { Language.new }

  it { is_expected.to respond_to(:locale) }
  it { is_expected.to respond_to(:displayable) }

  context "attributes" do

    subject { Language }

    its(:attributes) { is_expected.to eq( { locale: { type: :string }, displayable: { type: :boolean } } ) }

  end

end
