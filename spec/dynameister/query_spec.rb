require_relative "../app/models/book"

describe Dynameister::Query do

  let(:collection) { Dynameister::Collection.new(Book.client, "books" ) }

  before  { Book.create_table }

  after   { delete_table "books"}

  let(:query) { described_class.new(collection, Book) }

  describe "operation" do

    describe "scan" do

      subject { query }

      its(:operation) { is_expected.to eq :scan }

      it "equals after query call" do
        expect(subject.having(something: "anything").operation).to eq :scan
      end

      it "equals after or call" do
        expect(subject.or.operation).to eq :scan
      end

      it "equals after limit call" do
        expect(subject.limit(1).operation).to eq :scan
      end

      it "equals after count call" do
        subject.count
        expect(subject.operation).to eq :scan
      end

    end

    describe "query" do

      subject { described_class.new(collection, Book, :query) }

      describe "after query call" do

        its(:operation) { is_expected.to eq :query }

        it "equals after or call" do
          expect(subject.or.operation).to eq :query
        end

        it "equals after limit call" do
          expect(subject.limit(1).operation).to eq :query
        end

        describe "key condition expression" do

          let(:options) { { uuid: "some uuid" } }

          subject { described_class.new(collection, Book, :query).having(options).options }

          it "builds the query hash with a filter expression" do
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
        expect(subject[:expression_attribute_names]).to eq({ "#something" => "something" })
      end

      it "builds the query hash with expression attribute names" do
        expect(subject[:expression_attribute_values]).to eq({ ":something" => "anything" })
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
          ).to eq({ "#something" => "something", "#more" => "more" })
        end

        it "builds the query hash with expression attribute names" do
          expect(
            subject[:expression_attribute_values]
          ).to eq({ ":something" => "anything", ":more" => "of something" })
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
