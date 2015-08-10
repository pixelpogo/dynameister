module Dynameister
  module Indexes
    class Index

      attr_accessor :model, :name, :hash_keys, :range_keys

      def initialize(model, name, options = {})
        @model = model
        @hash_keys = name
        @range_keys = options[:range_key]
        @name = combined_keys
      end

      def table_name
        "index_#{model.table_name.singularize}_#{formatted_name}"
      end

      private

      def combined_keys
        [hash_keys, range_keys].compact.flatten
      end

      def formatted_name
        name.map(&:to_s).map(&:pluralize).join('_and_')
      end

    end
  end
end
