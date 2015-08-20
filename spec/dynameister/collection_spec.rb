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

  let(:model_class) { Language }

  subject { described_class.new(pager, model_class) }

  it "returns a collection of 2 elements" do
    expect(subject.count).to eq(2)
  end

  it "returns a collection of model instances" do
    expect(subject.all? { |model| model.instance_of? model_class }).to be_truthy
  end

  it "returns a paginated collection" do
    expect(subject.next_page?).to be_falsy
  end

  it "returns a paginated collection with a last page" do
    expect(subject.last_page?).to be_truthy
  end

end
