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
        client.table_names.include? table_name
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

    end

    def save
      persist
      self
    end

    def delete
      params = { self.class.hash_key => hash_key }
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
      client.put_item(table_name: table_name, item: attributes)
    end

  end

end
