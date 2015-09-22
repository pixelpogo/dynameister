require_relative "../errors"
require_relative "range_key"

module Dynameister

  module Indexes

    class LocalIndex

      LOCAL_INDEX_PREFIX = "by_"

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = build_range_key(range_key)
        @projection = options[:projection] || :all
      end

      def to_h
        { name: name, projection: projection }.merge(range_key.to_h)
      end

      private

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key.name}"
      end

      def build_range_key(range_key)
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
