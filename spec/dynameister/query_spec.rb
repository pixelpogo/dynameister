require_relative "../app/models/book"

describe Dynameister::Query do

  let(:table_name) { "books" }
  let(:query)      { described_class.new(Book) }

  before           { Book.create_table }
  after            { delete_table table_name }

  describe "operation" do

    describe "scan" do

      subject { query }

      its(:operation) { is_expected.to eq :scan_table }

      it "equals after query call" do
        expect(subject.having(something: "anything").operation).to eq :scan_table
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

      let(:options) { { something: "anything" } }

      it "builds the query hash with a filter expression" do
        expect(subject[:filter_expression]).to eq "#something = :something"
      end

      it "builds the query hash with expression attribute names" do
        expect(subject[:expression_attribute_names]).to eq("#something" => "something")
      end

      it "builds the query hash with expression attribute values" do
        expect(subject[:expression_attribute_values]).to eq(":something" => "anything")
      end

      context "combining queries" do

        subject { query.having(options).and(more: "of something").options }

        it "builds the query hash with a filter expression" do
          expect(
            subject[:filter_expression]
          ).to eq "#something = :something and #more = :more"
        end

        it "builds the query hash with expression attribute names" do
          expect(
            subject[:expression_attribute_names]
          ).to eq("#something" => "something", "#more" => "more")
        end

        it "builds the query hash with expression attribute names" do
          expect(
            subject[:expression_attribute_values]
          ).to eq(":something" => "anything", ":more" => "of something")
        end
      end

      context "combining or queries" do

        subject { query.having(options).or.having(more: "of something").options }

        it "builds the query hash with a filter expression" do
          expect(
            subject[:filter_expression]
          ).to eq "#something = :something or #more = :more"
        end

      end

      context "comparison" do

        subject { query.having(options).le(age: 42).options }

        it "builds the query hash with a filter expression" do
          expect(
            subject[:filter_expression]
          ).to eq "#something = :something and #age <= :age"
        end

      end

    end

  end

end
