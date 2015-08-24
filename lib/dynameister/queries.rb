require "dynameister/query"
require "dynameister/collection"

module Dynameister

  module Queries
    extend ActiveSupport::Concern

    module ClassMethods

      def query(options={})
        collection = Collection.new(client, table_name)
        Query.new(collection, self, :query).where(options)
      end

      def scan(options = {})
        collection = Collection.new(client, table_name)
        Query.new(collection, self).where(options)
      end

    end

  end

end
