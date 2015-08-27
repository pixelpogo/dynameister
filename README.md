# Dynameister

A Ruby convenience wrapper from Amazons DynamoDB.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynameister'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynameister

## Usage

### Environment variables

* `DYNAMEISTER_ENV`: defines the environment dynameister is running in, this is mainly important for testing locally and on a CI server as it defines which `/spec/.env.<environment>` file is loaded

### Turn your Model into a Document

Dynameister supports sensible defaults for creating a table. The default for `hash_key` (which is the primary key) is the `id` column, which does not have to be declared separately. Include the `Dynameister::Document` module in your model definition. Add fields to the model, for easy convenience methods on the attributes.

```ruby
class Cat
  include Dynameister::Document

  field :name
  field :lives, :integer
  field :likes_mice, :boolean
end
```

Defaults for table name and `hash_key` can be overridden on table creation. The custom `hash_key` does not have to be part of the fields definiton. It is implicitly defined, when added as a `hash_key`.

```ruby
class Cat
  include Dynameister::Document

  table name: "kittens", hash_key: :nickname
end
```

### Document Creation

First create the table for the model.

```ruby
Cat.create_table
cat = Cat.new(name: "Neko Atsume", lives: 9)
cat.likes_mice = true
cat.save
```

`save` saves the object in the previously created "cats" table. Also a unique identifier string is created for the `hash_key` which is the `id` column.

```ruby
cat.id #=> "C43b9fe9-e264-4544-8e48-fa64c5eb5ddc"
```

## Secondary Indexes

To improve access to data and faster queries, you can define indexes on fields. These indexes are only supported when the table is created using a hash-and-range key.

There are two different kinds of indexes supported by DynamoDB:

### Local Secondary Indexes

Only a different range key than in the table definition needs to be supplied here. The `hash_key` remains the same.

### Global Secondary Indexes

Different hash and range keys than defined on the table.

```ruby
class Cat
  field :pet_food
  field :feed_at, :datetime

  table hash_key: :name, range_key: :created_at

  local_index :feed_at # Uses feed_at as range key

  global_index [:pet_food, :feed_at] # Uses pet_food as hash key and feed_at as range key
end
```
The maximum number for both local and global indexes is five.

## Querying

Supported methods for querying:

* by hash_key (uses DynamoDB query)
* filter on matching values for attributes (uses DynamoDB scan)
* return a whole collection of documents (uses DynamoDB scan without a filter)
* return a limited number of documents

```ruby
# Perform a query using hash and range key.
# It is also possible for query to only receive the hash key.
# In this case all books with that hash key and - if present -
# different range keys would be returned.
Book.query(hash_key: "72c62052", range_key: 42)

# Same as above but uses get_item underneath
Book.find_by(hash_key: "a17871e56c14")

# Filter on other attributes other than the hash_key
Book.scan(author_id: 42)
```
When using scan with an attribute that corresponds to a local secondary index, internally it will use this index to optimise the query.

## Testing

1. Copy `spec/.env.test.template` to `spec/.env.test`,
2. Adapt `spec/.env.test` according to its comments,
3. Run `bundle exec rspec`.

## Contributing

Have a look at [existing issues](https://github.com/lessonnine/dynameister.gem/issues) first, please. Most of the time this is a good way to start getting used to the code base.

1. Fork it ( https://github.com/[my-github-username]/dynameister/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
