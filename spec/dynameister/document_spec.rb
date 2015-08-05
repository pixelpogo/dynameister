require_relative "../app/models/language"

describe Dynameister::Document do

  subject { Language.new(locale: "GER", displayable: true, rank: 42) }

  its(:locale)      { is_expected.to eq("GER") }
  its(:displayable) { is_expected.to eq(true) }
  its(:rank)        { is_expected.to eq(42) }

end
