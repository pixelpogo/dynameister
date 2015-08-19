describe Dynameister::Scan::Parameters do

  subject { described_class.new(model, options).to_h }

  describe "parameters for a model without indexes" do

    let(:model)   { double('model', table_name: 'models', local_indexes: []) }
    let(:options) { { age: 42 } }

    its([:table_name]) { is_expected.to eq "models" }
    its([:index_name]) { is_expected.to be_nil }

    context "with a single-attribute filter" do

      let(:options) { { age: 42 } }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age = :age"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq("#age" => "age")
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq(":age" => 42)
      end

    end

    context "with a multi-attribute filter" do

      let(:options) { { age: 42, name: "bob" } }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age = :age AND #name = :name"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq({ "#age" => "age", "#name" => "name" })
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq({ ":age" => 42, ":name" => "bob" })
      end

    end

  end

  describe "parameters for a model with local indexes" do

    let(:local_index) { Dynameister::Indexes::LocalIndex.new(:age).to_hash }
    let(:model)   { double('model', table_name: 'models', local_indexes: [local_index]) }
    let(:options) { { age: 42 } }

    its([:table_name]) { is_expected.to eq "models" }
    its([:index_name]) { is_expected.to eq "by_age" }

    context "with a single-attribute filter" do

      let(:options) { { age: 42 } }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age = :age"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq("#age" => "age")
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq(":age" => 42)
      end

    end

    context "with a multi-attribute filter" do

      let(:options) { { age: 42, name: "bob" } }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age = :age AND #name = :name"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq({ "#age" => "age", "#name" => "name" })
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq({ ":age" => 42, ":name" => "bob" })
      end

    end

  end

end
