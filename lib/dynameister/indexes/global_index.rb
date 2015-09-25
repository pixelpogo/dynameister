require_relative "../builder/key_builder"

module Dynameister

  module Indexes

    class GlobalIndex

      GLOBAL_INDEX_PREFIX      = "by_"
      GLOBAL_INDEX_CONJUGATION = "_and_"

      attr_accessor :hash_key, :range_key, :projection, :throughput

      def initialize(keys, options = {})
        @hash_key, @range_key = build_keys(keys)
        @projection = options[:projection] || :all
        @throughput = options[:throughput] || [1, 1]
      end

      def to_h
        {
          name:       name,
          hash_key:   hash_key.to_h,
          projection: projection,
          throughput: throughput
        }.merge(range_key.to_h)
      end

      private

      def build_keys(keys)
        [].tap do |a|
          a << Builder::KeyBuilder.build_hash_key(keys.first)
          a << Builder::KeyBuilder.build_range_key(keys.last) if keys.length > 1
        end
      end

      def name
        GLOBAL_INDEX_PREFIX + combined_keys
      end

      def combined_keys
        [hash_key, range_key]
          .compact
          .map(&:name)
          .map(&:to_s)
          .map(&:pluralize)
          .join(GLOBAL_INDEX_CONJUGATION)
      end

    end

  end

end
