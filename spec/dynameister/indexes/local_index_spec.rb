require_relative "shared_examples_for_indexes"

describe Dynameister::Indexes::LocalIndex do

  shared_examples_for "a local index" do

    subject { described_class.new(range_key, {}, options) }

    its(:name) { is_expected.to eq "by_adopted_at" }
    its(:projection) { is_expected.to eq projection }

    context "the range key" do

      subject { described_class.new(range_key, {}).range_key }

      its(:name) { is_expected.to eq :adopted_at }
      its(:type) { is_expected.to eq range_key_type }

    end

  end

  let(:range_key) { :adopted_at }

  context "default projection type" do

    let(:options) { {} }
    let(:projection) { :all }
    let(:range_key_type) { :string }

    it_behaves_like "a local index"

  end

  context "overriding the projection type" do

    let(:options) { { projection: projection } }
    let(:projection) { :keys_only }
    let(:range_key_type) { :string }

    it_behaves_like "a local index"

  end

  context "given a range key with explicit type" do

    subject { described_class.new(range_key, {}) }

    context "with valid format" do

      let(:range_key) { { adopted_at: range_key_type } }
      let(:options) { { projection: projection } }
      let(:projection) { :all }
      let(:range_key_type) { :string }

      it_behaves_like "a local index"

    end

    context "with invalid format" do

      let(:range_key) { 10 }

      it_behaves_like "a handler for an invalid format"

    end

  end

end
