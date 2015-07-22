module Dynameister

  class ItemSerializer

    def initialize(item)
      @item = item
      @attribute_serializer = Dynameister::AttributeValue.new
    end

    def put_item_hash
      @item.inject({}) do |hash, (key, value)|
        hash[key] = @attribute_serializer.marshal(value)

        hash
      end
    end

    def get_item_hash
      @item.inject({}) do |hash, (key,value)|
        hash[key] = @attribute_serializer.unmarshal(value)

        hash
      end
    end

  end

end
