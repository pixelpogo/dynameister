shared_examples_for "a handler for an invalid format" do

  it "raises an Dynameister::IndexKeyDefinitionError" do
    expect { subject }.to raise_exception(Dynameister::IndexKeyDefinitionError)
  end

end
