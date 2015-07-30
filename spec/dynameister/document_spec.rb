require_relative "../app/models/language"

describe Dynameister::Document do

  context "fields" do

    subject { Language.new }

    it { is_expected.to respond_to(:locale) }
    it { is_expected.to respond_to(:displayable) }

  end

end
