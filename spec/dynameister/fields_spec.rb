require_relative "../app/models/language"

describe Dynameister::Fields do


  subject { Language.new }

  it { is_expected.to respond_to(:locale) }
  it { is_expected.to respond_to(:rank) }
  it { is_expected.to respond_to(:displayable) }

  context "attributes" do

    subject { Language }

    its(:attributes) do is_expected.to eq(
       {
         id:          { type: :string },
         locale:      { type: :string },
         displayable: { type: :boolean },
         rank:        { type: :integer }
       }
     )
     end

  end

end

