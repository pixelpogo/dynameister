module Dynameister

  module Serializers

    class DeleteItemSerializer

      def initialize(table_name:, hash_key:)
        @table_name = table_name
        @hash_key   = hash_key
      end

      def to_h
        {
          table_name: @table_name,
          key:        @hash_key
        }
      end

    end

  end

end
