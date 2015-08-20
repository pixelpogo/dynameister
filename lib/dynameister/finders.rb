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
        response = Collection.new(client, table_name).scan(options)
        response.entities.map { |entity| new(entity) }
      end

    end

  end
end
