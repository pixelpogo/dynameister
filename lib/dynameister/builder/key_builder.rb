require_relative "../errors"

module Dynameister

  module Builder

    HashKey = Struct.new(:name, :type) do

      def to_h
        { name => type }
      end

    end

    RangeKey = Struct.new(:name, :type) do

      def to_h
        {
          range_key: { name => type }
        }
      end

    end

    class KeyBuilder

      def self.build_hash_key(hash_key)
        case hash_key
        when String, Symbol then HashKey.new(hash_key.to_sym, :string)
        when Hash           then HashKey.new(hash_key.keys.first,
                                             hash_key.values.first)
        else raise IndexKeyDefinitionError.new(hash_key)
        end
      end

      def self.build_range_key(range_key)
        case range_key
        when String, Symbol then RangeKey.new(range_key.to_sym, :number)
        when Hash           then RangeKey.new(range_key.keys.first,
                                              range_key.values.first)
        else raise IndexKeyDefinitionError.new(range_key)
        end
      end

    end

  end

end
