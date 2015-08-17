require_relative "../app/models/book"

describe Dynameister::Scan do

  before do
    Book.create_table
    Book.create(author_id: 42, rank: 2)
  end

  after { delete_table "books" }

  describe "scan, using a local index" do

    subject { Book.scan_parameters(author_id: 42) }

    it "derives the index from its local secondary index" do
      expect(subject[:index_name]).to eq "by_author_id"
    end

  end

  describe "scan returns a collection" do

    subject { Book.scan(author_id: 42) }

    it "returns the book matching the filter" do
      expect(subject.count).to eq 1
    end

   it "returns the book matching the filter for author_id" do
      expect(subject.map(&:author_id)).to eq [42]
    end

  end

end
