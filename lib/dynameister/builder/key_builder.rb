require_relative "../errors"

module Dynameister

  module Builder

    Key = Struct.new(:name, :type)

    class KeyBuilder

      def self.build_hash_key(hash_key)
        case hash_key
        when String, Symbol then Key.new(hash_key.to_sym, :string)
        when Hash           then Key.new(hash_key.keys.first,
                                         hash_key.values.first)
        else raise IndexKeyDefinitionError.new(hash_key)
        end
      end

      def self.build_range_key(range_key)
        case range_key
        when String, Symbol then Key.new(range_key.to_sym, :number)
        when Hash           then Key.new(range_key.keys.first,
                                         range_key.values.first)
        else raise IndexKeyDefinitionError.new(range_key)
        end
      end

    end

  end

end
