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

end
