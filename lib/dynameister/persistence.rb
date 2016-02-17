require 'securerandom'

module Dynameister

  module Persistence

    extend ActiveSupport::Concern

    module ClassMethods

      def table_name
        options.fetch(:name, name.demodulize.tableize)
      end

      def client
        @client ||= Dynameister::Client.new
      end

      def create_table(options: {})
        options =
          {
            range_key:      range_key,
            local_indexes:  local_indexes,
            global_indexes: global_indexes
          }.merge(options)

        unless table_exists?
          client.create_table(table_name: table_name, hash_key: hash_key, options: options)
        end
      end

      def table_exists?
        client.describe_table table_name: table_name
        true
      rescue Aws::DynamoDB::Errors::ResourceNotFoundException
        false
      end

      def create(attrs = {})
        new(attrs).save
      end

      def schema
        @schema ||= client.describe_table(table_name: table_name).table
      end

      def key_schema_keys
        schema[:key_schema].map do |key|
          key[:attribute_name].to_sym
        end
      end

      def serialize_attributes(item)
        item.each_with_object({}) do |(key, value), serialized_item|
          serialized_item[key] = serialize_attribute(key => value)[key]
        end
      end

      def serialize_attribute(attribute)
        key = attribute.keys.first
        if caster = attribute_casters[key]
          attribute[key] = caster.serialize(attribute[key])
        end
        attribute
      end

      def deserialize_attributes(raw_attributes)
        raw_attributes.each_with_object({}) do |(key, value), item|
          if caster = attribute_casters[key]
            item[key] = caster.deserialize(value)
          end
        end
      end

      def attribute_casters
        attributes.each_with_object({}) do |(key, value), rules|
          rules[key] = type_caster(type: value[:type])
        end.with_indifferent_access
      end

    end

    included do
      private_class_method :attribute_casters
    end

    def save
      persist
      self
    end

    def delete
      params = { self.class.hash_key.name => hash_key }
      client.delete_item(table_name: table_name, hash_key: params)
    end

    private

    def table_name
      self.class.table_name
    end

    def client
      self.class.client
    end

    def persist
      self.hash_key ||= SecureRandom.uuid unless hash_key
      serialized_attributes = self.class.serialize_attributes(attributes)
      client.put_item(table_name: table_name, item: serialized_attributes)
    end

  end

end
