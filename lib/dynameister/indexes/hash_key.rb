module Dynameister

  module Indexes

    HashKey = Struct.new(:name, :type) do

      def to_h
        { name => type }
      end

    end

  end

end
