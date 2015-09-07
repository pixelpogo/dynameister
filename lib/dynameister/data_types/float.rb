module Dynameister

  module DataTypes

    class Float < Value

      def type
        :float
      end

      private

      def cast_value(value)
        value.to_f
      end

    end

  end

end
