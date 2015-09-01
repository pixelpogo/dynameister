describe Dynameister::Indexes::GlobalIndex do

  let(:keys) { [:uuid, :created_at] }

  context "default projection type" do

    subject { described_class.new(keys) }

    it "has a hash representation" do
      expect(subject.to_h).to eq(
        name:       "by_uuids_and_created_ats",
        hash_key:   { uuid: :string },
        range_key:  { created_at: :number },
        projection: :all,
        throughput: [1, 1]
      )
    end

  end

  context "non-default projection type" do

    subject { described_class.new(keys, projection: :keys_only) }

    it "has a hash representation" do
      expect(subject.to_h).to eq(
        name:       "by_uuids_and_created_ats",
        hash_key:   { uuid: :string },
        range_key:  { created_at: :number },
        projection: :keys_only,
        throughput: [1, 1]
      )
    end

  end

  context "only providing a hash key" do

    subject { described_class.new([:uuid]) }

    it "has a hash representation" do
      expect(subject.to_h).to eq(
        name:       "by_uuids",
        hash_key:   { uuid: :string },
        projection: :all,
        throughput: [1, 1]
      )
    end

  end

  context "non-default throughput" do

    subject { described_class.new([:uuid], throughput: [2, 3]) }

    it "has a hash representation" do
      expect(subject.to_h).to eq(
        name:       "by_uuids",
        hash_key:   { uuid: :string },
        projection: :all,
        throughput: [2, 3]
      )
    end

  end

end
