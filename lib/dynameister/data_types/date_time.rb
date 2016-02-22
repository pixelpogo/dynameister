module Dynameister

  module DataTypes

    class DateTime < Value

      def type
        :datetime
      end

      def serialize(value)
        value.try(:iso8601, 6)
      end

      private

      def cast_value(value)
        ::Time.parse(value).to_datetime
      end

    end

  end

end
