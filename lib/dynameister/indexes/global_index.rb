require_relative "../key"

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

      def name
        GLOBAL_INDEX_PREFIX + combined_keys
      end

      private

      def build_keys(keys)
        [].tap do |a|
          a << Key.build_hash_key(keys.first)
          a << Key.build_range_key(keys.last) if keys.length > 1
        end
      end

      def hash_key_hash
        { hash_key.name => hash_key.type }
      end

      def range_key_hash
        {}.tap do |h|
          h[:range_key] = { range_key.name => range_key.type } if range_key
        end
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
