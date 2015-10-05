shared_examples_for "a handler for an invalid format" do

  it "raises an Dynameister::KeyDefinitionError" do
    expect { subject }.to raise_exception(Dynameister::KeyDefinitionError)
  end

end
