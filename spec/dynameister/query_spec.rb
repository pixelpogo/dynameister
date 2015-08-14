require_relative '../app/models/book'

describe Dynameister::Query do

  before do
    Book.create_table
    3.times { |n| Book.create(name: "Book#{n}", rank: n) }
  end

  after { delete_table "books" }

  describe "#all" do

    subject { Book.all }

    it "finds all records" do
      expect(subject.count).to eq(3)
    end

    it "returns an array with all the records' data" do
      expect(subject.map(&:name)).to match_array %w(Book0 Book1 Book2)
    end

    context "limit" do

      subject { Book.all(limit: 1) }

      it 'find all records with limit' do
        expect(subject.count).to eq(1)
      end

      it "returns an array with limited data" do
        expect(subject.first).to be_a Book
      end

    end

  end

  describe 'querying' do

    describe '#where' do

      let(:book) { Book.all[0] }

      subject do
        Book.where(uuid: book.uuid, rank: book.rank)
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

