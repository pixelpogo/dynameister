require_relative "../app/models/language"

describe Dynameister::Collection do

  let(:pager) do
    spy('pager', items: items, :'next_page?' => false, :'last_page?' => true)
  end

  let(:items) {
    [
      { id: 'id1', locale: 'Language1' },
      { id: 'id2', locale: 'Language2' }
    ]
  }

  subject { described_class.new(pager, Language) }

  it "returns a collection of 2 elements" do
    expect(subject.count).to eq(2)
  end

  it "returns a collection of model instances" do
    expect(subject.map(&:locale)).to eq %w(Language1 Language2)
  end

  it "returns a paginated collection" do
    expect(subject.next_page?).to be_falsy
  end

  it "returns a paginated collection with a last page" do
    expect(subject.last_page?).to be_truthy
  end

end
