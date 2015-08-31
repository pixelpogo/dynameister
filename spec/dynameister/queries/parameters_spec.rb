describe Dynameister::Queries::Parameters do

  shared_examples_for "a single-attribute filter" do

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

    describe "filter expression with sets of values" do

      let(:model)    { double('model', local_indexes: []) }
      let(:options)  { { age: [12, 42] } }
      let(:negation) { "not " }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "not #age in (:age0, :age1)"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq("#age" => "age")
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq(":age0" => 12, ":age1" => 42)

      end

    end

    describe "filter expression with ranges" do

      let(:options) { { age: 40..42 } }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age between :age0 and :age1"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq("#age" => "age")
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq(":age0" => 40, ":age1" => 42)

      end

    end

    describe "negated filter expression" do

      let(:options) { { age: [12, 42] } }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age in (:age0, :age1)"
      end

      it "includes proper expression attribute names" do
        expect(
          subject[:expression_attribute_names]
        ).to eq("#age" => "age")
      end

      it "includes proper expression attribute values" do
        expect(
          subject[:expression_attribute_values]
        ).to eq(":age0" => 12, ":age1" => 42)

      end

    end

  end

  subject { described_class.new(model, :filter_expression, options, comparator, negation).to_h }

  describe "parameters for a model without indexes" do

    let(:model)      { double('model', local_indexes: []) }
    let(:comparator) { "=" }
    let(:options)    { { age: 42 } }
    let(:negation)   { nil }

    it               { is_expected.to_not have_key(:index_name) }

    it_behaves_like "a single-attribute filter"

  end

  describe "parameters for a model with local indexes" do

    let(:local_index) { Dynameister::Indexes::LocalIndex.new(:age).to_h }
    let(:model)       { double('model', local_indexes: [local_index]) }
    let(:comparator)  { "=" }
    let(:options)     { { age: 42 } }
    let(:negation)    { nil }

    its([:index_name]) { is_expected.to eq "by_age" }

    it_behaves_like "a single-attribute filter"

  end

  describe "comparison operators" do

    let(:model)    { double('model', local_indexes: []) }
    let(:options)  { { age: 42 } }
    let(:negation) { nil }

    context "less than" do

      let(:comparator) { "<" }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age < :age"
      end

    end

    context "less or equal than" do

      let(:comparator) { "<=" }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age <= :age"
      end

    end

    context "greater than" do

      let(:comparator) { ">" }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age > :age"
      end

    end

    context "greater than or equal" do

      let(:comparator) { ">=" }

      it "includes a proper filter expression" do
        expect(subject[:filter_expression]).to eq "#age >= :age"
      end

    end

  end

end
