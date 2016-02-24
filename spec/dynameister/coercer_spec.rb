describe Dynameister::Coercer do

  describe "creating a key" do

    let(:schema) do
      { hej: { type: :datetime }, hola: { type: :float } }
    end

    describe "given a hash" do

      let(:key_information) { { hej: :integer } }

      context "given a schema for attributes" do

        subject do
          described_class.new(schema).create_key(key_information)
        end

        let(:schema) do
          { hej: { type: :datetime }, hola: { type: :float } }
        end

        it "derives its data type from the key information" do
          expect(subject.type).to eq :number
        end

        it "returns a key with a name" do
          expect(subject.name).to eq :hej
        end

      end

      context "without an attributes schema" do

        subject { described_class.new.create_key(key_information) }

        it "derives its data type from the key information" do
          expect(subject.type).to eq :number
        end

        it "returns a key with a name" do
          expect(subject.name).to eq :hej
        end

      end

    end

    describe "given a symbol" do

      context "with a schema for attributes" do

        subject { described_class.new(schema).create_key(:hola) }

        it "derives its data type from the schema" do
          expect(subject.type).to eq :number
        end

        it "returns a key with a name" do
          expect(subject.name).to eq :hola
        end

      end

      context "without an attributes schema" do

        subject { described_class.new.create_key(:hola) }

        it "returns a key with a default data type" do
          expect(subject.type).to eq :string
        end

        it "returns a key with a name" do
          expect(subject.name).to eq :hola
        end

      end

    end

    describe "given a string" do

      subject { described_class.new(schema).create_key("hola") }

      context "with a schema for attributes" do

        it "derives its data type from the schema" do
          expect(subject.type).to eq :number
        end

      end

      context "without an attributes schema" do

        subject { described_class.new.create_key("hola") }

        it "returns a key with a default data type" do
          expect(subject.type).to eq :string
        end

        it "returns a key with a name" do
          expect(subject.name).to eq :hola
        end

      end

    end

  end

end
