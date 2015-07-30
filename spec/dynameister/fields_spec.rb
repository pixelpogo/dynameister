require_relative "../app/models/language"

describe Dynameister::Fields do


  subject { Language.new }

  it { is_expected.to respond_to(:locale) }
  it { is_expected.to respond_to(:displayable) }

  context "attributes" do

    subject { Language.new.attributes }

    its(:keys)   { is_expected.to include(:locale, :displayable) }
    its(:values) { is_expected.to eq([{ type: :string }, { type: :boolean }]) }

  end

end
