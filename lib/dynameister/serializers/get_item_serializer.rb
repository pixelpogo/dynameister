module Dynameister

  module Serializers

    class GetItemSerializer

      attr_accessor :key

      def initialize(table_name:, key:)
        @table_name = table_name
        @key = key
      end

      def to_h
        {
          table_name: @table_name,
          key:        key
        }
      end

    end

  end

end
