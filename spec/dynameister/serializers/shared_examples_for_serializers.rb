shared_examples_for "a serializer that includes table name and hash key" do

  it "includes table_name" do
    expect(subject).to include(table_name: table_name)
  end

  it "includes the hash_key" do
    expect(subject[:key]).to include(hash_key)
  end

end
