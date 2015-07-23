module Dynameister

  class ItemSerializer

    def initialize(table_name: table_name, item: item)
      @table_name = table_name
      @item       = item
    end

    def put_item_hash
      {
        table_name: @table_name,
        item:       @item
      }
    end

  end

end