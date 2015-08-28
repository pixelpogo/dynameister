require "dynameister/query"
require "dynameister/collection"

module Dynameister

  module Queries

    extend ActiveSupport::Concern

    module ClassMethods

      def query(options = {})
        perform_operation(:query, options)
      end

      def scan(options = {})
        perform_operation(:scan, options)
      end

      def perform_operation(operation, options)
        collection = Collection.new(client, table_name)
        Query.new(collection, self, operation).having(options)
      end

    end

  end

end
