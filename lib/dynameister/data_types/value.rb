module Dynameister

  module DataTypes

    class Value

      include Singleton

      def type # :nodoc:
      end

      def deserialize(value)
        cast(value)
      end

      def serialize(value)
        value
      end

      def cast(value)
        cast_value(value) unless value.nil?
      end

      private

      def cast_value(value)
        value
      end

    end

  end

end
