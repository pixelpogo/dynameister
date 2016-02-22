module Dynameister

  module DataTypes

    class Time < Value

      def type
        :time
      end

      def serialize(value)
        value.try(:iso8601, 6)
      end

      private

      def cast_value(value)
        ::Time.parse value
      end

    end

  end

end
