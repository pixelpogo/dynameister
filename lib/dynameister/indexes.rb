require "dynameister/indexes/global_index"
require "dynameister/indexes/local_index"

module Dynameister

  module Indexes

    extend ActiveSupport::Concern

    included do
      class_attribute :local_indexes, :global_indexes

      self.local_indexes  = []
      self.global_indexes = []
    end

    module ClassMethods

      def local_index(range_key, options = {})
        local_index = LocalIndex.new(range_key, options)
        local_indexes << local_index.to_h
      end

      def global_index(keys, options = {})
        global_index = GlobalIndex.new(keys, options)
        global_indexes << global_index.to_h
      end

    end

  end

end
