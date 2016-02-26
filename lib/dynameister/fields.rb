module Dynameister

  module Fields

    extend ActiveSupport::Concern

    included do
      private_class_method :create_key_accessors!,
                           :create_hash_key_accessors?,
                           :create_range_key_accessors?

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
        name = options[:hash_key] || :id
        DataTypes::Coercer.new(attributes).create_key(name)
      end

      def range_key
        if name = options[:range_key]
          DataTypes::Coercer.new(attributes).create_key(name)
        end
      end

      def table(options = {})
        self.options = options

        create_key_accessors!
      end

      def remove_field(field)
        attributes.delete(field) || raise("No such field")
        remove_method field
        remove_method :"#{field}="
      end

      def create_key_accessors!
        if create_hash_key_accessors?
          remove_field :id
          field(hash_key.name, hash_key.type)
        end

        if create_range_key_accessors?
          field(range_key.name, range_key.type)
        end
      end

      def create_hash_key_accessors?
        !attributes.has_key?(hash_key.name)
      end

      def create_range_key_accessors?
        range_key.present? && !attributes.has_key?(range_key.name)
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
      send(self.class.hash_key.name)
    end

    def hash_key=(value)
      send("#{self.class.hash_key.name}=", value)
    end

    def range_key
      if range_key = self.class.range_key
        send(range_key.name)
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
