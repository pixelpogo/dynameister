require_relative "shared_examples_for_indexes"

describe Dynameister::Indexes::LocalIndex do

  let(:range_key) { :adopted_at }

  context "default projection type" do

    subject { described_class.new(range_key) }

    it "has a hash representation" do
      expect(subject.to_h).to eq(
        name:       "by_adopted_at",
        range_key:  { range_key => :number },
        projection: :all
      )
    end

  end

  context "overriding the projection type" do

    subject { described_class.new(range_key, projection: :keys_only) }

    it "has a hash representation" do
      expect(subject.to_h).to eq(
        name:       "by_adopted_at",
        range_key:  { range_key => :number },
        projection: :keys_only
      )
    end

  end

  context "given a range key with explicit type" do

    subject { described_class.new(range_key) }

    context "with valid format" do

      let(:range_key) { { adopted_at: :string } }

      it "has a hash representation" do
        expect(subject.to_h).to eq(
          name:       "by_adopted_at",
          range_key:  range_key,
          projection: :all
        )
      end

    end

    context "with invalid format" do

      let(:range_key) { 10 }

      it_behaves_like "a handler for an invalid format"

    end

  end

end
