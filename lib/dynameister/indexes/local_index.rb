require_relative "../coercer"

module Dynameister

  module Indexes

    class LocalIndex

      LOCAL_INDEX_PREFIX = "by_".freeze

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = Coercer.new.create_key(range_key)
        @projection = options[:projection] || :all
      end

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key.name}"
      end

    end

  end

end
