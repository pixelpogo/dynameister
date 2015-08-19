require_relative '../app/models/book'

describe Dynameister::Query do

  before do
    Book.create_table
    3.times { |n| Book.create(name: "Book#{n}", rank: n, author_id: 42) }
  end

  after { delete_table "books" }


  describe "query with a given hash_key" do

    let(:book) { Book.all[0] }

    subject { Book.query(uuid: book.uuid).all }

    it "returns a record by hash key" do
      expect(subject.count).to eq(1)
    end

    it "returns the book with the corresponding attritbutes" do
      expect(subject.first.uuid).to eq book.uuid
    end

  end

  describe "combining queries" do

    subject { Book.query(uuid: book.uuid).and(name: book.name).all }

    it "returns a book for a given hash_key and name" do
      expect(subject.name).to eq book.name
    end

  end


end
