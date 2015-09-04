shared_examples_for "a DataType that can serialize and deserialize values in both ways" do

  it "deserializes a serialized value correctly" do
    expect(subject.deserialize(subject.serialize(attribute))).to eq attribute
  end

  it "serializes a deserialized value into the same value as the initial serialized value" do
    expect(subject.serialize(subject.deserialize(subject.serialize(attribute)))).to eq subject.serialize(attribute)
  end

end
