require_relative "../app/models/book"

describe Dynameister::Queries do

  let(:book) { Book.create(author_id: 42, rank: 2, name: "bog") }

  before do
    Book.create_table
    book
  end

  after { delete_table "books" }

  describe "scan returns a collection" do

    context "scanning with one attribute" do

      subject { Book.scan(name: "bog").all }

      it "returns one book matching the filter" do
        expect(subject.count).to eq 1
      end

      it "returns the book matching the filter for author_id" do
        expect(subject.first.uuid).to eq book.uuid
      end

    end

    context "scanning with multiple attributes" do

      subject { Book.scan(name: "bog").and(rank: 2).all }

      it "returns one book matching the filter" do
        expect(subject.count).to eq 1
      end

      it "returns the book matching the filter for author_id" do
        expect(subject.first.uuid).to eq book.uuid
      end

    end

  end

  describe "contains in" do

    before do
      3.times { |n| Book.create(author_id: n, rank: n, name: "bog#{n}") }
    end

    context "array with integers" do

      subject { Book.scan(author_id: [0,2] ).all }

      it "returns the books matching the filter" do
        expect(subject.count).to eq 2
      end

      it "returns the books matching the filter for author_id" do
        expect(subject.map(&:author_id)).to match_array [0,2]
      end

    end

    context "selecting from names" do

      subject { Book.scan(name: %w(bog1 bog2) ).all }

      it "returns the books matching the filter" do
        expect(subject.count).to eq 2
      end

      it "returns the books matching the filter for names" do
        expect(subject.map(&:name)).to match_array %w(bog1 bog2)
      end

    end

    context "count" do

      subject { Book.scan(name: %w(bog1 bog2) ).count }

      it "counts the collection" do
        expect(subject).to eq 2
      end

    end

    describe "comparison" do

      context "there is a book matching the criteria" do

        subject { Book.scan(name: "bog1").le(rank: 2).all }

        it "returns the book with a rank less than 2" do
          expect(subject.count).to eq 1
        end

      end

      context "combining queries" do

        subject { Book.scan(name: "bog1").or.le(rank: 2) }

        it "returns the " do
          expect(subject.count).to eq 4
        end

      end

      context "no book with matching criteria" do

        subject { Book.scan(name: "bog1").le(rank: 0).all }

        it "no books are returned" do
          expect(subject.count).to eq 0
        end

      end

    end

  end

end

