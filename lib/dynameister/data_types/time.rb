module Dynameister

  module DataTypes

    class Time < Value

      def type
        :time
      end

      def serialize(value)
        value.as_json
      end

      private

      def cast_value(value)
        ::Time.parse value
      end

    end

  end

end
