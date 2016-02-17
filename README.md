[![Build Status](https://travis-ci.org/babbel/dynameister.svg?branch=master)](https://travis-ci.org/babbel/dynameister)


# Dynameister

A Ruby convenience wrapper for Amazons DynamoDB.

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

### Configuration

Dynameister provides some configuration options:

* `read_capacity`: Defines the **default** provisioned throughput for read requests, see [read capacity units](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ProvisionedThroughputIntro.html#ProvisionedThroughputIntro.Reads).
* `write_capacity`: Defines the **default** provisioned throughput for write requests, see [write capacity units](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ProvisionedThroughputIntro.html#ProvisionedThroughputIntro.Writes).
* `endpoint`: As mentioned above this is only necessary when [DynamoDB Local](https://aws.amazon.com/de/blogs/aws/dynamodb-local-for-desktop-development/) is used.
* `region`: Specifies the AWS Region for DynamoDB tables. It overwrites the global configuration of the AWS SDK (e.g. `ENV[‚AWS_REGION‘]`), so that different AWS regions can be used in parallel.
* `credentials`: Allows to configure custom [AWS credentials](http://docs.aws.amazon.com/sdkforruby/api/Aws/Credentials.html). Only required for local and/or testing environment. In production environments you should always load your credentials from outside your application, e.g. the AWS SDK loads it from environment variables automatically. Avoid configuring credentials statically and never commit them to source control.

This is how Dynameister can be configured, e.g. in an initializer in a Rails app:

```ruby
  Dynameister.configure do |config|
    config.read_capacity 1000
    config.write_capacity 350
    # config.endpoint "http://192.168.99.100:32768"
    config.region "eu-west-1"
    config.credentials Aws::Credentials.new( "access_key_id", "secret_access_key","session_token")
  end
```



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

#### DataTypes

In addition to the default [DynamoDB DataTypes for AttributeValues](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_AttributeValue.html) Dynameister offers a few more datatypes

 * `:datetime`
 * `:float`
 * `:integer`
 * `:time`

The values of custom DataType attributes will be automatically converted (serialized) into DynamoDB compliant DataTypes before they are stored.

They are reconverted (deserialized) back into the non-default DataTypes when they are retrieved from DynamoDB.

```ruby
class CompactDisc
  include Dynameister::Document

  field :name
  field :tracks, :integer
  field :price, :float
  field :release_date, :datetime
  field :produced_at, :time
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

Only a different range key than in the table definition needs to be supplied here. The hash key remains the same.

### Global Secondary Indexes

Different hash and range keys than defined on the table.

### Examples

```ruby
# Hash and range keys for the table and the secondary
# indexes in this example use the default types :string
# (hash key) and :number (range key).

class Cat
  field :pet_food
  field :feed_at, :datetime

  table hash_key: :name, range_key: :created_at

  local_index :feed_at # Uses feed_at as range key

  global_index [:pet_food, :feed_at] # Uses pet_food as hash key and feed_at as range key
end
```

```ruby
# The types for hash and range keys for the table and the
# secondary indexes in this example get partly overridden.
# You can choose between :string, :number and :binary.

class Cat
  field :pet_food
  field :feed_at, :datetime

  table hash_key: { name: :number }, range_key: { created_at: :string }

  local_index :feed_at

  global_index [ { pet_food: :number }, :feed_at]
end
```

### Important notes on Secondary Indexes

* The maximum number for both local and global indexes is five.
* If you define hash and/or range key(s) via the `table` method in your model those definitions will take precedence over any `field` definitions for the corresponding hash and/or range key(s).

## Querying

Supported methods for querying:

* `query` by hash_key (uses DynamoDB `query`)
* `find` with a single hash_key (uses DynamaDB `get_item`)
* `find` with an array of hash_keys (uses DynamoDb `scan`)
* filter on matching values for attributes (uses DynamoDB `scan`)
* `all` return a whole collection of documents (uses DynamoDB `scan` without a filter)

The Queries are built lazily, via the DSL for adding attributes to the query and comparison or logical operators.
Calling `.all` on the query, will execute the query and return the result.

### Queries

DynamoDB query should be used whenever the `hash_key` or additionally the `range_key` is available.

```ruby
# Perform a query using hash and range key.
# It is also possible for query to only receive the hash key.
# In this case all books with that hash key and - if present -
# different range keys would be returned.
Book.query(hash_key: "72c62052").all # or
Book.query(hash_key: "72c62052").and(range_key: 42).all
Book.query(hash_key: "72c62052").and(range_key: 42).limit(1)

# You can also do comparisons on the range_key,
# e.g. returning objects with ranges less than or equal to 42
Book.query(hash_key: "72c62052").le(range_key: 42).all

# Same as above but uses get_item underneath
Book.find_by(hash_key: { uuid: "a17871e56c14" })
Book.find("a17871e56c14")

# Using DynamoDB scan
Book.find ["ane85rna", "nelg94", "h384hen"] # only for compliance with ActiveRecord API
Book.all  # no filter
```

### Scans

DynamoDB scan can be used when filtering on any attribute. A Scan operation reads every item in a table or a secondary index.

Using
```ruby

# Filter on other attributes other than the hash_key
Book.scan(author_id: 42)

# Combining attributes for filtering
Book.scan(author_id: 42).and(locale: "DE").all # finds all books with author_id 42 and locale DE
Book.scan(author_id: 42).or.having(locale: "DE").all # finds all books with author_id 42 or locale DE
Book.scan(author_id: 42).lt(rank: 42).all # finds all the books with author_id # 42 and a rank less than 42
# Contains in
Book.scan(author_id: [40, 41, 42]).all # providing an array with values will return all books with author_ids in 40, 41, 42
# Between values
Book.scan(author_id: 1..3).all # providing a range will return all books with author_ids
                               # greater than or equal to 1, and less than or equal to 3.

```

#### Comparison operators

The default is equals `=`. Aliases are `and`, `eq`, `in` and `between`.

Other supported operators are:
* Less than or equal to `<=`, as `le`
* Greater than `>`, as `gt`
* Less than`<`, as `lt`
* Greater than or equal to `>=`, as `ge`
* Negation `NOT`, as `not` or `exclude`

When using scan with an attribute that corresponds to a local secondary index, internally it will use this index to optimise the query.

## Development

We use [rubocop](https://github.com/bbatsov/rubocop) to ensure our code style guide in combination with [HoundCI](https://houndci.com). This means that when you create a pull request on Github HoundCI will analyse your changes and automatically comment on statements that do not comply with our style guide.

To avoid too many complaints of HoundCI in your pull request use a [plugin for your code editor](https://github.com/bbatsov/rubocop#editor-integration). This allows you to get notified about not complying statements before your pull request is created.

## Testing

In order to run the rspec test suite please enter

`bundle exec rspec`

Dynameister expects *DynamoDBLocal* to be running on localhost on port 8000. If you’re local environment is different, then you have to specify `ENV['DYNAMEISTER_ENDPOINT‘]`.

e.g. `DYNAMEISTER_ENDPOINT=somehost:12345 bundle exec rspec`


## Contributing

Have a look at [existing issues](https://github.com/lessonnine/dynameister.gem/issues) first, please. Most of the time this is a good way to start getting used to the code base.

1. Fork it ( https://github.com/[my-github-username]/dynameister/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Dynameister is released under the [MIT License](http://www.opensource.org/licenses/MIT).
