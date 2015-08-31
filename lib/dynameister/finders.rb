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

      def find(*hash_keys)
        hash_keys = Array(hash_keys.flatten.uniq)
        if hash_keys.count == 1
          find_by(hash_key: { hash_key => hash_keys.first })
        else
          find_all(hash_keys)
        end
      end

      # We have to use `scan` here, because `query` does not allow
      # the contains in operator `in`, only scan supports this

      def find_all(hash_keys)
        options = { hash_key => hash_keys }
        scan(options).all
      end

    end

  end

end
