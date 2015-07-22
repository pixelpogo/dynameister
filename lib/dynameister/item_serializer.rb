module Dynameister

  class ItemSerializer

    def initialize(item)
      @item = item
      @attribute_serializer = Dynameister::AttributeValue.new
    end

    def put_item_hash
      @item.each_with_object({}) do |(key, value), hash|
        hash[key] = @attribute_serializer.marshal(value)
      end
    end

    def get_item_hash
      @item.each_with_object({}) do |(key, value), hash|
        hash[key] = @attribute_serializer.unmarshal(value)
      end
    end

  end

end
