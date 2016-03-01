require "dynameister/collection"

module Dynameister

  module Finders

    extend ActiveSupport::Concern

    module ClassMethods

      def find(hash, range = nil)
        return destructure_params(hash) if hash.is_a?(Array)

        keys = {}.tap do |k|
          k[hash_key.name] = hash
          k[range_key.name] = range if range_key && range
        end
        find_by(key: keys)
      end

      def find_by(key:)
        retrieved = client.get_item(table_name: table_name, key: key)
        if retrieved.empty?
          nil
        else
          new(deserialize_attributes(retrieved.item))
        end
      end

      def all(options = {})
        limit = options.delete(:limit)
        scan(options).limit(limit).all
      end

      private

      def destructure_params(params)
        if params[0].is_a?(Array) && range_key # check for multi-array
          params.flatten.each_slice(2).map { |h, r| find h, r }.compact
        else
          params.map { |elem| find elem }.compact
        end
      end

    end

  end

end
