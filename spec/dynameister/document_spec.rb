require_relative "../app/models/language"

describe Dynameister::Document do

  let(:language) { Language.new  }

  it "has an attribute named locale" do
    expect(language).to respond_to(:locale)
  end

  # its { is_expected.to respond_to(:displayable) }

end
