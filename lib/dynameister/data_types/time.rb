module Dynameister

  module DataTypes

    class Time < Value

      def type
        :time
      end

      def serialize(value)
        value.to_r.to_s
      end

      private

      def cast_value(value)
        ::Time.at(value.to_r)
      end

    end

  end

end
