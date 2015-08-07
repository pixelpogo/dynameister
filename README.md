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

Dynameister currently only supports a default for the table name. The default for hash_key is the :id column, which does not have to be declared separately. Include the module in your model definition. Add fields to the model, for easy convenience methods on the attributes.

```ruby
class Cat
  include Dynameister::Document

  field :name
  field :lives, :integer
  field :likes_mice, :boolean
end
```

### Document Creation

First create the table for the model. It will create a table with the name "cats".

```ruby
Cat.create_table
cat = Cat.new(name: "Neko Atsume", lives: 9)
cat.likes_mice = true
cat.save

```

Save saves the object in the previously created "cats" table. Also a unique identifier string is created for the hash_key which is the :id column.

```ruby
cat.id #=> "C43b9fe9-e264-4544-8e48-fa64c5eb5ddc"
```

### Custom Hash Key

If you want to override the default hash_key, you can declare the hash_key on the model. This key also has to be part of the fields' declaration.

```ruby
class Cat
  include Dynameister::Document

  table hash_key: :name

  field :name
end
```

## Testing

1. Copy `spec/.env.test.template` to `spec/.env.test`,
2. Adapt `spec/.env.test` according to its comments,
3. Run `bundle exec rspec`.

## Contributing

Have a look at our [ToDo list](https://github.com/lessonnine/dynameister.gem/blob/master/TODO.md) first, please.

1. Fork it ( https://github.com/[my-github-username]/dynameister/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
