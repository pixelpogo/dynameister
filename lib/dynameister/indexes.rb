require 'dynameister/indexes/index'

module Dynameister

  module Indexes
    extend ActiveSupport::Concern

    included do
      class_attribute :indexes

      self.indexes = {}
    end

    module ClassMethods

      def index(name, options = {})
        index = Index.new(self, name, options)
        self.indexes[index.name] = index
        create_indexes
      end

      def create_indexes
        self.indexes.each do |name, index|
          self.create_table(opts)
        end
      end

    end

  end

end
