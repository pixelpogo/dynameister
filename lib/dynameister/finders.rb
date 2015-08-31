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

      def all(options = {})
        limit = options.delete(:limit)
        scan(options).limit(limit).all
      end

    end

  end

end
