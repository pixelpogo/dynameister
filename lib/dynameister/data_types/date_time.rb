module Dynameister

  module DataTypes

    class DateTime < Value

      def type
        :datetime
      end

      def serialize(value)
        value.as_json
      end

      private

      def cast_value(value)
        ::Time.parse(value).to_datetime
      end

    end

  end

end
