module Dynameister
  module Fields
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes
      self.attributes = {}

      field :id
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

    def update_attributes(attributes)
      unless attributes.nil? || attributes.empty?
        attributes.each do |attribute, value|
          self.write_attribute(attribute, value)
        end
      save
      end
    end

    def write_attribute(name, value)
      attributes[name.to_sym] = value
    end

    private

    def read_attribute(name)
      attributes[name.to_sym]
    end
  end
end
