module Dynameister
  module Indexes
    class LocalIndex

      LOCAL_INDEX_PREFIX = "by_"

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = range_key
        @projection = options[:projection] || :all
      end

      def to_h
        { name: name, range_key: { range_key => :number }, projection: projection }
      end

      private

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key}"
      end

    end
  end
end
