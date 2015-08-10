module Dynameister
  module Indexes
    class LocalIndex

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = range_key
        @projection = options[:projection] || :all
      end

      def to_hash
        { name: name, range_key: range_key, projection: projection }
      end

      private

      def name
        "by_#{range_key.keys.first.to_s}"
      end

    end
  end
end
