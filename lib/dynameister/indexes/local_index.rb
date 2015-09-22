module Dynameister

  module Indexes

    class LocalIndex

      RangeKey = Struct.new(:name, :type) do

        def to_h
          {
            range_key: { name => type }
          }
        end

      end

      LOCAL_INDEX_PREFIX = "by_"

      attr_accessor :range_key, :projection

      def initialize(range_key, options = {})
        @range_key = build_range_key(range_key)
        @projection = options[:projection] || :all
      end

      def to_h
        { name: name, projection: projection }.merge(range_key.to_h)
      end

      private

      def name
        "#{LOCAL_INDEX_PREFIX}#{range_key.name}"
      end

      def build_range_key(range_key)
        case range_key
        when String, Symbol then RangeKey.new(range_key.to_sym, :number)
        when Hash           then RangeKey.new(range_key.keys.first,
                                              range_key.values.first)
        else raise_build_range_key_error(range_key)
        end
      end

      def raise_build_range_key_error(range_key)
        raise ArgumentError, <<-EOS
                Not supported range key type #{range_key} for local index.
                Supported types are String/Symbol for a default range key of
                type :number and Hash to define a range key of type :string,
                :number or :binary.
              EOS
      end

    end

  end

end
