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

Dynameister currently only supports defaults for table name, and hash_key. The default for hash_key is the :id column, which does not have to be declared seperately. Include the module in your model definition. On first time model creation, it will also create the table for the model for you. Add fields to the model, for easy convenience methods on the attributes.

```ruby
class Cat
  include Dynameister::Document

  field :name
  field :age, :integer
  field :likes_mice, :boolean
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
