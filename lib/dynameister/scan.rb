module Dynameister

  module Scan
    extend ActiveSupport::Concern

    module ClassMethods

      def scan(opts={})
        params = scan_parameters(opts)
        response = self.client.scan_table(params)
        Collection.new(response, self)
      end

      def scan_parameters(opts)
        params = {}.tap do |hash|
          hash[:table_name] = self.table_name
          hash[:index_name] = find_local_index_for_attributes(opts)
        end
        params.merge!(filter_expression(opts))
      end

      private

      def find_local_index_for_attributes(opts)
        local_indexes = []
        opts.each do |attribute, _|
          local_indexes << self.local_indexes.detect do |index|
            index[:range_key].keys.first == attribute
          end
        end
        local_indexes.first[:name] if local_indexes.any?
      end

      def filter_expression(opts)
        expression_attribute_names  = {}
        expression_attribute_values = {}

        opts.each do |key, value|
          expression_attribute_names["##{key}"]  = key.to_s
          expression_attribute_values[":#{key}"] = value
        end

        expression_attributes = Hash[expression_attribute_names.keys.zip(expression_attribute_values.keys)]

        {
          filter_expression:           build_filter_expression(expression_attributes),
          expression_attribute_names:  expression_attribute_names,
          expression_attribute_values: expression_attribute_values
        }
      end

      def build_filter_expression(expression_attributes)
        expression_attributes.each_with_object([]) do |(name, value), filter|
          filter << "#{name} = #{value}"
        end.join(" AND ")
      end

    end
  end

end
