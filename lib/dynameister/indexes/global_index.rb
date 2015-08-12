module Dynameister
  module Indexes
    class GlobalIndex

      GLOBAL_INDEX_PREFIX = "by_"

      attr_accessor :keys, :projection, :throughput

      def initialize(keys, options = {})
        @keys       = keys
        @projection = options[:projection] || :all
        @throughput = options[:throughput] || [1,1]
      end

      def to_hash
        {
          name:       name,
          hash_key:   hash_key,
          projection: projection,
          throughput: throughput
        }.merge(range_key)
      end

      private

      def hash_key
        { keys.first => :string }
      end

      def range_key
        if keys.length > 1
          { range_key: { keys.last => :number } }
        else
          {}
        end
      end

      def name
        GLOBAL_INDEX_PREFIX + combined_keys
      end

      def combined_keys
        keys.map(&:to_s).map(&:pluralize).join('_and_')
      end

    end
  end
end
