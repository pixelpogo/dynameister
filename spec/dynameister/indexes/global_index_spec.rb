require_relative "shared_examples_for_indexes"

describe Dynameister::Indexes::GlobalIndex do

  let(:keys) { [:uuid, :created_at] }

  context "default projection type" do

    subject { described_class.new(keys, {}) }

    its(:name) { is_expected.to eq "by_uuids_and_created_ats" }
    its(:projection) { is_expected.to eq :all }
    its(:throughput) { is_expected.to eq [1, 1] }

    context "the hash key" do

      subject { described_class.new(keys, {}).hash_key }

      its(:name) { is_expected.to eq :uuid }
      its(:type) { is_expected.to eq :string }

    end

    context "the range key" do

      subject { described_class.new(keys, {}).range_key }

      its(:name) { is_expected.to eq :created_at }
      its(:type) { is_expected.to eq :number }

    end

  end

  context "non-default projection type" do

    subject { described_class.new(keys, {}, projection: :keys_only) }

    its(:name) { is_expected.to eq "by_uuids_and_created_ats" }
    its(:projection) { is_expected.to eq :keys_only }
    its(:throughput) { is_expected.to eq [1, 1] }

    context "the hash key" do

      subject { described_class.new(keys, {}).hash_key }

      its(:name) { is_expected.to eq :uuid }
      its(:type) { is_expected.to eq :string }

    end

    context "the range key" do

      subject { described_class.new(keys, {}).range_key }

      its(:name) { is_expected.to eq :created_at }
      its(:type) { is_expected.to eq :number }

    end

  end

  context "providing a hash and range key" do

    subject { described_class.new(keys, {}) }

    context "with custom type" do

      let(:keys) { [:uuid, created_at: :string] }

      its(:name) { is_expected.to eq "by_uuids_and_created_ats" }
      its(:projection) { is_expected.to eq :all }
      its(:throughput) { is_expected.to eq [1, 1] }

      context "the hash key" do

        subject { described_class.new(keys, {}).hash_key }

        its(:name) { is_expected.to eq :uuid }
        its(:type) { is_expected.to eq :string }

      end

      context "the range key" do

        subject { described_class.new(keys, {}).range_key }

        its(:name) { is_expected.to eq :created_at }
        its(:type) { is_expected.to eq :string }

      end

      context "with invalid format" do

        let(:keys) { [:uuid, 10] }

        it_behaves_like "a handler for an invalid format"

      end

    end

  end

  context "only providing a hash key" do

    subject { described_class.new(keys, {}) }

    context "with default type" do

      let(:keys) { [:uuid] }

      its(:name) { is_expected.to eq "by_uuids" }
      its(:projection) { is_expected.to eq :all }
      its(:throughput) { is_expected.to eq [1, 1] }

      context "the hash key" do

        subject { described_class.new(keys, {}).hash_key }

        its(:name) { is_expected.to eq :uuid }
        its(:type) { is_expected.to eq :string }

      end

      context "the range key" do

        subject { described_class.new(keys, {}).range_key }

        it { is_expected.to be_nil }

      end

    end

    context "with custom type" do

      let(:keys) { [uuid: :number] }

      its(:name) { is_expected.to eq "by_uuids" }
      its(:projection) { is_expected.to eq :all }
      its(:throughput) { is_expected.to eq [1, 1] }

      context "the hash key" do

        subject { described_class.new(keys, {}).hash_key }

        its(:name) { is_expected.to eq :uuid }
        its(:type) { is_expected.to eq :number }

      end

      context "the range key" do

        subject { described_class.new(keys, {}).range_key }

        it { is_expected.to be_nil }

      end

      context "with invalid format" do

        let(:keys) { [10] }

        it_behaves_like "a handler for an invalid format"

      end

    end

  end

  context "non-default throughput" do

    subject { described_class.new(keys, {}, throughput: [2, 3]) }

    let(:keys) { [:uuid] }

    its(:name) { is_expected.to eq "by_uuids" }
    its(:projection) { is_expected.to eq :all }
    its(:throughput) { is_expected.to eq [2, 3] }

    context "the hash key" do

      subject { described_class.new(keys, {}).hash_key }

      its(:name) { is_expected.to eq :uuid }
      its(:type) { is_expected.to eq :string }

    end

    context "the range key" do

      subject { described_class.new(keys, {}).range_key }

      it { is_expected.to be_nil }

    end

  end

end
