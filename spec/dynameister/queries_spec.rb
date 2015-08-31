require_relative "../app/models/book"

describe Dynameister::Queries do

  let(:book) { Book.create(author_id: 42, rank: 42, name: "bog") }

  before do
    Book.create_table
    book
  end

  after { delete_table "books" }

  describe "query with a given hash_key" do

    subject { Book.query(uuid: book.uuid).all }

    it "returns a record by hash key" do
      expect(subject.count).to eq(1)
    end

    it "returns the book with the uuid" do
      expect(subject.first.uuid).to eq book.uuid
    end

  end

  describe "query with a hash and range key" do

    subject { Book.query(uuid: book.uuid).and(rank: book.rank).all }

    it "returns the book with the given hash and range keys" do
      expect(subject.first.rank).to eq book.rank
    end
  end

  describe "combining queries" do

    subject do
      Book.query(uuid: book.uuid).and(rank: book.rank).and(name: book.name).all
    end

    it "returns a book for a given hash_key and name" do
      expect(subject.first.rank).to eq book.rank
    end

  end

  describe "#or" do

    let!(:other_book) { Book.create(rank: 99, author_id: 1, name: "my book") }

    subject { Book.scan(name: book.name).or.having(rank: other_book.rank) }

    it "returns the 2 books matching the filter" do
      expect(subject.count).to eq 2
    end

  end

  describe "scan returns a collection" do

    context "scanning with one attribute" do

      subject { Book.scan(name: "bog").all }

      it "returns one book matching the filter" do
        expect(subject.count).to eq 1
      end

      it "returns the book matching the filter for name" do
        expect(subject.first.name).to eq "bog"
      end

    end

    context "scanning with multiple attributes" do

      subject { Book.scan(name: "bog").and(rank: book.rank).all }

      it "returns one book matching the filter" do
        expect(subject.count).to eq 1
      end

      it "returns the book matching the filter for name and rank" do
        expect(subject.first.name).to eq "bog"
      end

    end

  end

  describe "contains in" do

    before do
      3.times { |n| Book.create(author_id: n, rank: n, name: "bog#{n}") }
    end

    context "array with integers" do

      subject { Book.scan(author_id: [0, 2]).all }

      it "returns the books matching the filter" do
        expect(subject.count).to eq 2
      end

      it "returns the books matching the filter for author_id" do
        expect(subject.map(&:author_id)).to match_array [0, 2]
      end

    end

    context "selecting from names" do

      subject { Book.scan(name: %w(bog1 bog2)).all }

      it "returns the books matching the filter" do
        expect(subject.count).to eq 2
      end

      it "returns the books matching the filter for names" do
        expect(subject.map(&:name)).to match_array %w(bog1 bog2)
      end

    end

    context "count" do

      subject { Book.scan(name: %w(bog1 bog2)).count }

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

        subject { Book.scan(name: "bog1").or.le(rank: 2).all }

        it "returns the matching book" do
          expect(subject.count).to eq 3
        end

      end

      context "no book with matching criteria" do

        subject { Book.scan(name: "bog1").le(rank: 0).all }

        it "no books are returned" do
          expect(subject.count).to eq 0
        end

      end

    end

    describe "between two values" do

      subject { Book.scan(author_id: 40..42).all }

      it "returns the books with author_id greater than or equal to 40, and less than or equal to 42" do
        expect(subject.count).to eq 1
      end

    end

    describe "limit" do

      before do
        3.times { |n| Book.create(author_id: n, rank: n, name: "bog#{n}") }
      end

      subject { Book.scan(rank: [0, 1, 2]).limit(1).all }

      it "limits the number of results" do
        expect(subject.count).to eq 1
      end
    end

  end

  describe "negation" do

    context "no matching filter" do
      subject { Book.scan(name: book.name).not.having(rank: book.rank).all }

      it "does not return a book" do
        expect(subject.count).to eq 0
      end
    end

    context "matching filter" do
      subject { Book.scan(name: book.name).not.having(rank: 1).all }

      it "does not return a book" do
        expect(subject.count).to eq 1
      end
    end

    context "with comparison" do
      subject { Book.scan(name: book.name).not.ge(rank: 43).all }

      it "does not return a book" do
        expect(subject.count).to eq 1
      end
    end

    context "between values" do
      subject { Book.scan(name: book.name).not.between(rank: 2..9).all }

      it "does not return a book" do
        expect(subject.count).to eq 1
      end
    end

  end

end
