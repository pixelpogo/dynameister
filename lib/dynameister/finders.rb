require "dynameister/collection"

module Dynameister

  module Finders

    extend ActiveSupport::Concern

    module ClassMethods

      def find_by(hash_key:)
        retrieved = client.get_item(table_name: table_name, hash_key: hash_key)
        if retrieved.empty?
          nil
        else
          new(retrieved.item)
        end
      end

      def all(opts = {})
        options =
          {
            table_name: table_name,
            attributes_to_get: attributes.keys
          }
        options.merge!(opts.slice(:limit))

        response = client.scan_table(options)
        Collection.new(response, self)
      end

    end

  end

end
