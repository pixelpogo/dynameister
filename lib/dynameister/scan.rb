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
        params.merge!(scan_filter: scan_filter(opts))
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

      def scan_filter(opts)
        opts.each_with_object({}) do |(key, value), hash|
          hash[key] =
            {
              attribute_value_list: [value],
              comparison_operator:  "EQ"
            }
        end
      end

    end
  end

end
