module Dynameister

  module DataTypes

    class Integer < Value

      def type
        :integer
      end

      private

      def cast_value(value)
        value.to_i
      end

    end

  end

end
