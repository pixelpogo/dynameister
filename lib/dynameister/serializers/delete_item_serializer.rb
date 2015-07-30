module Dynameister

  module Serializers

    class DeleteItemSerializer

      def initialize(table_name:, hash_key:, range_key: nil)
        @table_name = table_name
        @hash_key   = hash_key
        @range_key  = range_key
      end

      def to_h
        {
          table_name: @table_name,
          key:        key
        }
      end

      private

      def key
        @hash_key.merge(@range_key || {})
      end

    end

  end

end
