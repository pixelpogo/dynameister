module Dynameister

  module Queries

    class Parameters

      def initialize(model, expression_key, options = {}, comparator = "=")
        @model          = model
        @expression_key = expression_key
        @options        = options
        @comparator     = comparator
      end

      def to_h
        index = find_local_index_for_attributes
        params = {}
        params.merge!(index_name: index) if index
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
        local_indexes.compact.first[:name] if local_indexes.any?
      end

      def filter_expression
        expression_attributes = build_expression_attributes

        {
          @expression_key =>           build_filter_expression(expression_attributes),
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
          attributes[:values]            = expression_attribute_values(key, value)
        end
      end

      def expression_attribute_values(key, value)
        expression_values ||= case
                              when value.is_a?(Array)
                                value.each_with_object({}).with_index do |(val, hash), index|
                                  hash[":#{key}#{index}"] = val
                                end
                              when value.is_a?(Range)
                                [value.first, value.last].each_with_object({}).with_index do |(val, hash), index|
                                  hash[":#{key}#{index}"] = val
                                end
                              else
                                {":#{key}" => value }
                              end
      end


      def build_filter_expression(expression_attributes)
        key_mapping = expression_attribute_key_mapping(expression_attributes)
        name, values = key_mapping.keys.first, key_mapping.values.flatten
        filter ||= case
                   when @options.values.first.is_a?(Array)
                     "#{name} in (#{values.join(', ')})"
                   when @options.values.first.is_a?(Range)
                     "#{name} between #{values.first} and #{values.last}"
                   else
                     "#{name} #{@comparator} #{values.first}"
                   end
      end

      def expression_attribute_key_mapping(expression_attributes)
        names = expression_attributes[:names].keys.first
        values = expression_attributes[:values].keys
        { names => values }
      end

    end

  end

end
