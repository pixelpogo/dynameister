require_relative "../app/models/compact_disc"

describe Dynameister::DataTypes do

  before { CompactDisc.create_table }
  after { delete_table "compact_discs" }

  let(:name) { "Give Me Convenience or Give Me Death" }
  let(:tracks) { 17 }
  let(:price) { 9.99 }
  let(:release_date) { DateTime.new(1987, 6, 1) }
  let(:produced_at) { Time.new(1987, 5, 1) }

  let(:cd) do
    CompactDisc.create(
      name: name,
      tracks: tracks,
      price: price,
      release_date: release_date,
      produced_at: produced_at)
  end

  describe "creating a document" do

    subject { cd }

    it "serializes :datetime attributes" do
      expect(CompactDisc.type_caster(type: :datetime)).to receive(:serialize).once.with(release_date)
      subject
    end

    it "serializes :float attributes" do
      expect(CompactDisc.type_caster(type: :float)).to receive(:serialize).once.with(price)
      subject
    end

    it "serializes :integer attributes" do
      expect(CompactDisc.type_caster(type: :integer)).to receive(:serialize).once.with(tracks)
      subject
    end

    it "serializes :time attributes" do
      expect(CompactDisc.type_caster(type: :time)).to receive(:serialize).once.with(produced_at)
      subject
    end

    it "serializes default attributes" do
      expect(CompactDisc.type_caster(type: nil)).to receive(:serialize).at_least(:once).and_call_original
      subject
    end

  end

  describe "retrieving a document" do

    subject { CompactDisc.find_by(hash_key: { id: cd.id }) }

    it "deserializes :datetime attributes" do
      expect(CompactDisc.type_caster(type: :datetime)).to receive(:deserialize).once
      subject
    end

    it "deserializes :float attributes" do
      expect(CompactDisc.type_caster(type: :float)).to receive(:deserialize).once
      subject
    end

    it "deserializes :integer attributes" do
      expect(CompactDisc.type_caster(type: :integer)).to receive(:deserialize).once
      subject
    end

    it "deserializes :time attributes" do
      expect(CompactDisc.type_caster(type: nil)).to receive(:deserialize).at_least(:once)
      subject
    end

    it "has identical name attribute" do
      expect(subject.name).to eq name
    end

    it "has identical price attribute" do
      expect(subject.price).to eq price
    end

    it "has identical tracks attribute" do
      expect(subject.tracks).to eq tracks
    end

    it "has identical release_date attribute" do
      expect(subject.release_date).to eq release_date
    end

    it "has identical produced_at attribute" do
      expect(subject.produced_at).to eq produced_at
    end

  end

end
