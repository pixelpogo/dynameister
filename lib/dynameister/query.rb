require "dynameister/collection"

module Dynameister

  module Query

    extend ActiveSupport::Concern

    module ClassMethods

      def query(opts = {})
        params = query_parameters(opts)
        response = client.query_table(params)
        Collection.new(response, self)
      end

      def query_parameters(opts)
        limit = opts.delete(:limit)
        exclusive_start_key = opts.delete(:exclusive_start_key)

        key_conditions = opts.inject({}) do |memo, (key, value)|
          memo[key] =
            {
              attribute_value_list: [value],
              comparison_operator:  "EQ"
            }

          memo
        end

        params = { table_name: table_name }
        params.merge!(key_conditions: key_conditions)
        params.merge!(limit: limit) if limit
        params.merge!(exclusive_start_key: exclusive_start_key) if exclusive_start_key
        params
      end

    end

  end

end
