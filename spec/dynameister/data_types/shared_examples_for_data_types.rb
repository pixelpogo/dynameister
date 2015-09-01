shared_examples_for "a DataType that can serialize and deserialize values in both ways" do

  it "deserializes a serialized value correctly" do
    expect(subject.cast(subject.serialize(attribute))).to eq attribute
  end

  it "serializes a deserialized value is the same as serializing the initial value" do
    expect(subject.serialize(subject.cast(attribute))).to eq subject.serialize(attribute)
  end

end
