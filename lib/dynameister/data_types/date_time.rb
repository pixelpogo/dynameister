module Dynameister

  module DataTypes

    class DateTime < Value

      def type
        :datetime
      end

      def serialize(value)
        BigDecimal.new(value.to_f.to_s)
      end

      private

      def cast_value(value)
        Time.at(value).to_datetime
      end

    end

  end

end
