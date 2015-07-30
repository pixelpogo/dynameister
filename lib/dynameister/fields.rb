module Dynameister
  module Fields
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes
      self.attributes = {}
    end

    module ClassMethods

      def field(name, type = :string, options = {})
        method_name = name.to_s

        define_method(method_name) { }
      end

    end
  end
end
