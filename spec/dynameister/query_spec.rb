require_relative '../app/models/book'

describe Dynameister::Query do

  before do
    Book.create_table
  end

  let!(:book) { Book.create(name: "bog", rank: 42, author_id: 2) }

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

# describe "query with a hash and range key" do

  #   subject { Book.query(uuid: book.uuid).and(rank: 42) }

  #   it "returns the book with the given hash and range keys" do

  #    hash =  {:key_condition_expression=>"#rank = :rank and #uuid = :uuid",
  #       :expression_attribute_names=>{"#rank"=>"rank", "#uuid"=>"uuid" },
  #       :expression_attribute_values=>{":rank"=>42, ":uuid"=>book.uuid }, table_name: "books"}
  #     binding.pry
  #     #expect(subject.first)
  #   end
  # end

  describe "combining queries" do

    subject do
      Book.query(uuid: book.uuid).and(rank: book.rank).and(name: book.name)
    end

    xit "returns a book for a given hash_key and name" do
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

    let!(:other_book)  { Book.create(rank: 99, author_id: 1, name: "my book") }

    subject do
      Book.query(uuid: book.uuid).or.query(name: "bog").and(author_id: 1)
    end

    xit "returns the book" do
      expect(subject.first.uuid).to eq book.uuid
    end

  end
end
