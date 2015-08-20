require_relative '../app/models/book'

describe Dynameister::Query do

  before do
    Book.create_table
  end

  let!(:book) { Book.create(name: "my book", rank: 42, author_id: 2) }

  after { delete_table "books" }

  describe "query with a given hash_key" do

    subject { Book.query(uuid: book.uuid).all }

    it "returns a record by hash key" do
      expect(subject.count).to eq(1)
    end

    it "returns the book with the corresponding attritbutes" do
      expect(subject.first.uuid).to eq book.uuid
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

  describe "#limit" do

    subject { Book.query(uuid: book.uuid).limit(1).all }

    it "limits the nummber of results" do
      expect(subject.count).to eq 1
    end

  end

  describe "#or" do

    before { Book.create(uuid: "my id", rank: 99, author_id: 1, name: "my book") }

    subject { Book.query(uuid: book.uuid).or.query(name: "my book", author_id: 1) }

    xit "returns " do
    end


  end
end
