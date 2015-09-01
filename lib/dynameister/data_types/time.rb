module Dynameister

  module DataTypes

    class Time < Value

      def type
        :time
      end

      def serialize(value)
        BigDecimal.new(value.to_f.to_s)
      end

      private

      def cast_value(value)
        ::Time.at(value)
      end

    end

  end

end
