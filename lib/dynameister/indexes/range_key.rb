module Dynameister

  module Indexes

    RangeKey = Struct.new(:name, :type) do

      def to_h
        {
          range_key: { name => type }
        }
      end

    end

  end

end
