require "dynameister/query"
require "dynameister/collection"

module Dynameister

  module Queries

    extend ActiveSupport::Concern

    module ClassMethods

      def query(options = {})
        perform_operation(:query_table, options)
      end

      def scan(options = {})
        perform_operation(:scan_table, options)
      end

      def perform_operation(operation, options)
        Query.new(self, operation).having(options)
      end

    end

  end

end
