module Dynameister

  module Serializers

    class PutItemSerializer

      def initialize(table_name: table_name, item: item)
        @table_name = table_name
        @item       = item
      end

      def to_h
        {
          table_name: @table_name,
          item:       @item
        }
      end

    end

  end

end
