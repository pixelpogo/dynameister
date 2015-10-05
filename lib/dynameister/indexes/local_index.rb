require_relative "../key"

module Dynameister

  module Indexes

    class LocalIndex

      LOCAL_INDEX_PREFIX = "by_"

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = Key.build_range_key(range_key)
        @projection = options[:projection] || :all
      end

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key.name}"
      end

    end

  end

end
