module Dynameister

  module Fields

    extend ActiveSupport::Concern

    included do
      class_attribute :attributes, :options
      self.attributes = {}
      self.options    = {}

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
        options[:hash_key] || :id
      end

      def range_key
        { options[:range_key] => :number } if options[:range_key]
      end

      def table(options = {})
        self.options = options
        unless attributes.has_key? hash_key
          remove_field :id
          field(hash_key)
        end
      end

      def remove_field(field)
        attributes.delete(field) || raise("No such field")
        remove_method field
        remove_method :"#{field}="
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
      send("#{self.class.hash_key}=", value)
    end

    def range_key
      if range_key = self.class.range_key
        send(range_key)
      end
    end

    def range_key=(value)
      send("#{self.class.range_key}=", value)
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
