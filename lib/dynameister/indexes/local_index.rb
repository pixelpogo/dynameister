require_relative "../builder/key_builder"

module Dynameister

  module Indexes

    class LocalIndex

      LOCAL_INDEX_PREFIX = "by_"

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = Builder::KeyBuilder.build_range_key(range_key)
        @projection = options[:projection] || :all
      end

      def to_h
        { name: name, projection: projection }.merge(range_key.to_h)
      end

      private

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key.name}"
      end

    end

  end

end
