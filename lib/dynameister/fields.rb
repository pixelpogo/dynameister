module Dynameister
  module Fields
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes, :options
      self.attributes = {}
      self.options = {}

      #TODO: default for hash key, add option to override
      field :id
    end

    module ClassMethods

      def field(name, type = :string, options = {})
        method_name = name.to_s

        field_attributes = { name => { type: type }.merge(options) }
        self.attributes  = attributes.merge(field_attributes)

        define_method(method_name)       { read_attribute(method_name) }
        define_method("#{method_name}=") { |value| write_attribute(method_name, value) }
      end

      def hash_key
        options[:key] || :id
      end

    end

    attr_accessor :attributes

    def update_attributes(attributes)
      unless attributes.nil? || attributes.empty?
        attributes.each do |attribute, value|
          write_attribute(attribute, value)
        end
        save
      end
    end

    def hash_key
      send(self.class.hash_key)
    end

    def hash_key=(value)
      self.send("#{self.class.hash_key}=", value)
    end

    private

    def write_attribute(name, value)
      attributes[name.to_sym] = value
    end

    def read_attribute(name)
      attributes[name.to_sym]
    end

  end
end

