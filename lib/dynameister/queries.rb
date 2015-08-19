require "dynameister/query"

module Dynameister

  module Queries
    extend ActiveSupport::Concern

    module ClassMethods

      def query(opts={})
        Query.new()
      end

    end


  end

end
