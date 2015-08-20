module Dynameister

  module Scan

    class Parameters

      def initialize(model, options = {})
        @model   = model
        @options = options
      end

      def to_h
        params = {}.tap do |hash|
          hash[:table_name] = @model.table_name

          index = find_local_index_for_attributes
          hash[:index_name] = index if index
        end
        params.merge!(filter_expression)
      end

      private

      def find_local_index_for_attributes
        local_indexes = []
        @options.each do |attribute, _|
          local_indexes << @model.local_indexes.detect do |index|
            index[:range_key].keys.first == attribute
          end
        end
        local_indexes.first[:name] if local_indexes.any?
      end

      def filter_expression
        expression_attributes = build_expression_attributes

        {
          filter_expression:           build_filter_expression(expression_attributes),
          expression_attribute_names:  expression_attributes[:names],
          expression_attribute_values: expression_attributes[:values]
        }
      end

      def build_expression_attributes
        initial = {
          names:  {},
          values: {}
        }

        @options.each_with_object(initial) do |(key, value), attributes|
          attributes[:names]["##{key}"]  = key.to_s
          attributes[:values][":#{key}"] = value
        end
      end

      def build_filter_expression(raw_expression_attributes)
        expression_attributes = Hash[
          raw_expression_attributes[:names]
            .keys
            .zip(raw_expression_attributes[:values].keys)
        ]

        expression_attributes.each_with_object([]) do |(name, value), filter|
          filter << "#{name} = #{value}"
        end.join(" AND ")
      end

    end

  end

end
