require_relative "errors"

module Dynameister

  Key = Struct.new(:name, :type) do

    AWS_DATA_TYPE = {
      time:     :string,
      datetime: :string,
      integer:  :number,
      float:    :number,
      string:   :string,
      number:   :number,
      binary:   :binary
    }.freeze

    def self.create_hash_key(hash_key)
      create_key(hash_key, :hash)
    end

    def self.create_range_key(range_key)
      create_key(range_key, :range)
    end

    def self.create_key(key_information, key_type)
      case key_information
      when String, Symbol then Key.new(key_information.to_sym, default_key_data_type(key_type))
      when Hash           then map_to_aws_data_type(key_information)
      else raise KeyDefinitionError.new(key_information, key_type)
      end
    end

    def self.default_key_data_type(type)
      type == :hash ? :string : :number
    end

    def self.map_to_aws_data_type(key_definition)
      Key.new(key_definition.keys.first, AWS_DATA_TYPE[key_definition.values.first])
    end

    private_class_method :create_key
    private_class_method :default_key_data_type
    private_class_method :map_to_aws_data_type

  end

end
