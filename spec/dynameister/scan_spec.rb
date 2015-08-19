require_relative "../app/models/book"

describe Dynameister::Scan do

  let(:book) { Book.create(author_id: 42, rank: 2) }

  before do
    Book.create_table
    book
  end

  after { delete_table "books" }

  describe "scan returns a collection" do

    context "scanning with one attribute" do

      subject { Book.scan(author_id: 42) }

      it "returns one book matching the filter" do
        expect(subject.count).to eq 1
      end

      it "returns the book matching the filter for author_id" do
        expect(subject.first.uuid).to eq book.uuid
      end

    end

    context "scanning with multiple attributes" do

      subject { Book.scan(author_id: 42, rank: 2) }

      it "returns one book matching the filter" do
        expect(subject.count).to eq 1
      end

      it "returns the book matching the filter for author_id" do
        expect(subject.first.uuid).to eq book.uuid
      end

    end

  end

end
