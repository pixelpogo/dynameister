shared_examples_for "a DataType that can serialize and deserialize values in both ways" do

  it "deserializes a serialized value correctly" do
    expect(subject.cast(subject.serialize(datetime))).to eq datetime
  end

  it "serializes a deserialized value is the same as serializing the initial value" do
    expect(subject.serialize(subject.cast(datetime))).to eq subject.serialize(datetime)
  end

end
