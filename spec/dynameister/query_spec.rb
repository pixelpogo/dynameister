require_relative '../app/models/book'

describe Dynameister::Query do

  before do
    Book.create_table
    3.times { |n| Book.create(name: "Book#{n}", rank: n, author_id: 42) }
  end

  after { delete_table "books" }

  describe 'querying' do

    describe 'query with a given hash_key' do

      let(:book) { Book.all[0] }

      subject do
        Book.query(uuid: book.uuid, rank: book.rank)
      end

      it "returns a record by hash key and range key" do
        expect(subject.count).to eq(1)
      end

      it "returns the book with the corresponding attritbutes" do
        expect(subject.first.rank).to eq book.rank
      end

    end

  end

end

