require_relative "../app/models/language"

describe Dynameister::Document do

  let(:table_name) { "languages"}

  after { Dynameister::Client.new.delete_table table_name: table_name }

  subject { Language.new(locale: "GER", displayable: true) }

  its(:locale) { is_expected.to eq("GER") }
  its(:displayable) { is_expected.to eq(true) }

  context "defaults for model" do

    subject { Language }

    its(:table_name) { is_expected.to eq(table_name) }

  end

  context "object initialization" do

    before { subject.save }

    it "creates the table for the object" do
      expect(Dynameister::Client.new.table_names).to include(table_name)
    end

    it "does not create an additional table if it already exists" do
      expect{ subject.save }.not_to raise_exception
    end

  end

end
