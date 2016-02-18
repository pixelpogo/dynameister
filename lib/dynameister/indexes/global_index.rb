require_relative "../key"

module Dynameister

  module Indexes

    class GlobalIndex

      GLOBAL_INDEX_PREFIX      = "by_".freeze
      GLOBAL_INDEX_CONJUGATION = "_and_".freeze

      attr_accessor :hash_key, :range_key
      attr_accessor :projection, :throughput
      attr_accessor :attribute_schema

      def initialize(keys, attribute_schema, options = {})
        @attribute_schema     = attribute_schema
        @hash_key, @range_key = build_keys(keys)
        @projection           = options[:projection] || :all
        @throughput           = options[:throughput] || [1, 1]
      end

      def name
        GLOBAL_INDEX_PREFIX + combined_keys
      end

      private

      def build_keys(keys)
        typed_keys = data_types_for_keys(keys)
        [].tap do |a|
          a << Key.create_hash_key(typed_keys.first)
          a << Key.create_range_key(typed_keys.last) if typed_keys.length > 1
        end
      end

      def data_types_for_keys(keys)
        if keys.length > 1
          [data_type_for(keys.first), data_type_for(keys.last)]
        else
          [data_type_for(keys.first)]
        end
      end

      def data_type_for(key)
        if attribute_schema[key]
          { key => attribute_schema[key][:type] }
        else
          key
        end
      end

      def combined_keys
        combined_keys_names.map(&:pluralize).join(GLOBAL_INDEX_CONJUGATION)
      end

      def combined_keys_names
        [hash_key, range_key].compact.map(&:name).map(&:to_s)
      end

    end

  end

end
