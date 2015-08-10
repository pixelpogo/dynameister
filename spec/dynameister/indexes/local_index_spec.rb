describe Dynameister::Indexes::LocalIndex do

  let(:range_key) { { attack_strength: :number } }


  context " default projection type" do

    subject { described_class.new(range_key) }

    it "has a hash representation" do
      expect(subject.to_hash).to eq(
        {
          name: "by_attack_strength",
          range_key: range_key,
          projection: :all
        }
      )
    end

  end

  context "overriding the projection type" do

    subject { described_class.new(range_key, { projection: :keys_only }) }

    it "has a hash representation" do
      expect(subject.to_hash).to eq(
        {
          name: "by_attack_strength",
          range_key: range_key,
          projection: :keys_only
        }
      )
    end

  end



end

