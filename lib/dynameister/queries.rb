require "dynameister/query"
require "dynameister/collection"

module Dynameister

  module Queries
    extend ActiveSupport::Concern

    module ClassMethods

      def query(opts={})
        collection = Collection.new(client, table_name, self.hash_key)
        Query.new(collection, self).query(opts)
      end

    end


  end

end
