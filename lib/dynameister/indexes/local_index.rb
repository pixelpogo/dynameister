require "dynameister/data_types/coercer"

module Dynameister

  module Indexes

    class LocalIndex

      LOCAL_INDEX_PREFIX = "by_".freeze

      attr_accessor :range_key, :schema, :projection

      def initialize(key, schema, options = {})
        @range_key = build_key(key, schema)
        @projection = options[:projection] || :all
      end

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key.name}"
      end

      private

      def build_key(key, schema)
        DataTypes::Coercer.new(schema).create_key(key)
      end

    end

  end

end
