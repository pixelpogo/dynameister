require_relative "errors"

module Dynameister

  class Coercer

    Key = Struct.new(:name, :type)

    DEFAULT_AWS_DATA_TYPE = :string

    AWS_DATA_TYPE = {
      time:     :string,
      datetime: :string,
      integer:  :number,
      float:    :number,
      string:   :string,
      number:   :number,
      binary:   :binary
    }.freeze

    attr_accessor :schema

    def initialize(schema = {})
      @schema = schema.with_indifferent_access
    end

    def create_key(key_information)
      case key_information
      when String, Symbol then Key.new(key_information.to_sym,
                                       to_aws_type(key_information))
      when Hash           then Key.new(key_information.keys.first,
                                       AWS_DATA_TYPE[key_information.values.first])
      else raise KeyDefinitionError.new(key_information)
      end
    end

    private

    def to_aws_type(name)
      data_type = extract_type_from_schema(name)
      AWS_DATA_TYPE[data_type]
    end

    def extract_type_from_schema(name)
      schema[name] ? schema[name][:type] : DEFAULT_AWS_DATA_TYPE
    end

  end

end
