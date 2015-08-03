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

        field_attributes = { name => { type: type }.merge(options) }
        self.attributes  = attributes.merge(field_attributes)

        define_method(method_name) { read_attribute(method_name) }
        define_method("#{method_name}=") { |value| write_attribute(method_name, value) }
      end

    end

    attr_accessor :attributes

    private

    def write_attribute(name, value)
      attributes[name.to_sym] = value
    end

    def read_attribute(name)
      attributes[name.to_sym]
    end
  end
end
