require "dynameister/errors"

module Dynameister

  module DataTypes

    class Coercer

      Key = Struct.new(:name, :type)

      attr_accessor :schema

      def initialize(schema = {})
        @schema = schema.with_indifferent_access
      end

      def create_key(key_information)
        case key_information
        when String, Symbol then Key.new(key_information.to_sym,
                                         to_aws_type(key_information))
        when Hash           then Key.new(key_information.keys.first,
                                         map_aws_data_type(key_information.values.first))
        else raise KeyDefinitionError.new(key_information)
        end
      end

      private

      def to_aws_type(name)
        data_type = extract_type_from_schema(name)
        map_aws_data_type(data_type)
      end

      def extract_type_from_schema(name)
        if schema[name]
          schema[name][:type]
        else
          DEFAULT_AWS_DATA_TYPE
        end
      end

      def map_aws_data_type(type)
        AWS_DATA_TYPE_MAP[type]
      end

    end

  end

end
