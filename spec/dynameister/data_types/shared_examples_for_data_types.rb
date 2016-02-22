shared_examples_for "a DataType that can serialize and deserialize values in both ways" do

  it "deserializes a serialized value correctly" do
    expect(subject.deserialize(subject.serialize(attribute))).to eq attribute
  end

  it "deserializes a serialized nil correctly" do
    expect(subject.deserialize(subject.serialize(nil))).to be_nil
  end

  it "serializes a deserialized value into the same value as the initial serialized value" do
    expect(subject.serialize(subject.deserialize(subject.serialize(attribute)))).to eq subject.serialize(attribute)
  end

  it "serializes a deserialized nil value back into nil" do
    expect(subject.serialize(subject.deserialize(subject.serialize(nil)))).to be_nil
  end
end
