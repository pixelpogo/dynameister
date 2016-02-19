require_relative "../app/models/book"

describe Dynameister::Query do

  let(:table_name) { "books" }
  let(:query)      { described_class.new(Book) }

  before           { Book.create_table }
  after            { Book.delete_table }

  describe "operation" do

    describe "scan" do

      subject { query }

      its(:operation) { is_expected.to eq :scan_table }

      it "equals after query call" do
        expect(subject.having(name: "anything").operation).to eq :scan_table
      end

      it "equals after or call" do
        expect(subject.or.operation).to eq :scan_table
      end

      it "equals after limit call" do
        expect(subject.limit(1).operation).to eq :scan_table
      end

      it "equals after count call" do
        subject.count
        expect(subject.operation).to eq :scan_table
      end

    end

    describe "query" do

      subject { described_class.new(Book, :query_table) }

      describe "after query call" do

        its(:operation) { is_expected.to eq :query_table }

        it "equals after or call" do
          expect(subject.or.operation).to eq :query_table
        end

        it "equals after limit call" do
          expect(subject.limit(1).operation).to eq :query_table
        end

        describe "key condition expression" do

          let(:options) { { uuid: "some uuid" } }

          subject { described_class.new(Book, :query_table).having(options).options }

          it "builds the query hash with the correct key" do
            expect(subject[:key_condition_expression]).to eq "#uuid = :uuid"
          end

        end

      end

    end

    describe "options" do

      subject { query.having(options).options }

      let(:options) { { name: "anything" } }

      it "builds the query hash with a filter expression" do
        expect(subject[:filter_expression]).to eq "#name = :name"
      end

      it "builds the query hash with expression attribute names" do
        expect(subject[:expression_attribute_names]).to eq("#name" => "name")
      end

      it "builds the query hash with expression attribute values" do
        expect(subject[:expression_attribute_values]).to eq(":name" => "anything")
      end

      context "combining queries" do

        subject { query.having(options).and(uuid: "of name").options }

        it "builds the query hash with a filter expression" do
          expect(
            subject[:filter_expression]
          ).to eq "#name = :name and #uuid = :uuid"
        end

        it "builds the query hash with expression attribute names" do
          expect(
            subject[:expression_attribute_names]
          ).to eq("#name" => "name", "#uuid" => "uuid")
        end

        it "builds the query hash with expression attribute names" do
          expect(
            subject[:expression_attribute_values]
          ).to eq(":name" => "anything", ":uuid" => "of name")
        end
      end

      context "combining or queries" do

        subject { query.having(options).or.having(uuid: "of name").options }

        it "builds the query hash with a filter expression" do
          expect(
            subject[:filter_expression]
          ).to eq "#name = :name or #uuid = :uuid"
        end

      end

      context "comparison" do

        subject { query.having(options).le(rank: 42).options }

        it "builds the query hash with a filter expression" do
          expect(
            subject[:filter_expression]
          ).to eq "#name = :name and #rank <= :rank"
        end

      end

    end

  end

end
