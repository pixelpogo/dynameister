require_relative "errors"

module Dynameister

  class Coercer

    Key = Struct.new(:name, :type)

    attr_accessor :schema

    DEFAULT_AWS_DATA_TYPE =
      {
        hash:  :string,
        range: :number
      }.freeze

    AWS_DATA_TYPE = {
      time:     :string,
      datetime: :string,
      integer:  :number,
      float:    :number,
      string:   :string,
      number:   :number,
      binary:   :binary
    }.freeze

    def initialize(schema = {})
      @schema = schema
    end

    def create_hash_key(hash_key)
      create_key(hash_key, :hash)
    end

    def create_range_key(range_key)
      create_key(range_key, :range)
    end

    private

    def create_key(key_information, key_type)
      case key_information
      when String, Symbol then Key.new(key_information.to_sym, default_data_type(key_type))
      when Hash           then map_to_aws_data_type(key_information)
      else raise KeyDefinitionError.new(key_information, key_type)
      end
    end

    def default_data_type(key_type)
      DEFAULT_AWS_DATA_TYPE[key_type]
    end

    def map_to_aws_data_type(key_definition)
      Key.new(key_definition.keys.first, AWS_DATA_TYPE[key_definition.values.first])
    end

  end

end
