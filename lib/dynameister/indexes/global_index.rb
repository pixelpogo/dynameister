require "dynameister/data_types/coercer"

module Dynameister

  module Indexes

    class GlobalIndex

      GLOBAL_INDEX_PREFIX      = "by_".freeze
      GLOBAL_INDEX_CONJUGATION = "_and_".freeze

      attr_accessor :hash_key, :range_key
      attr_accessor :projection, :throughput
      attr_accessor :schema

      def initialize(keys, schema, options = {})
        @schema               = schema
        @hash_key, @range_key = build_keys(keys)
        @projection           = options[:projection] || :all
        @throughput           = options[:throughput] || [1, 1]
      end

      def name
        GLOBAL_INDEX_PREFIX + combined_keys
      end

      private

      def build_keys(keys)
        [].tap do |a|
          a << DataTypes::Coercer.new(schema).create_key(keys.first)
          if keys.length > 1
            a << DataTypes::Coercer.new(schema).create_key(keys.last)
          end
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
