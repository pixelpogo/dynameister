require 'securerandom'

module Dynameister
  module Document
    extend ActiveSupport::Concern

    include Dynameister::Fields

    module ClassMethods

      def table_name
        name.demodulize.tableize
      end

      def client
        @client ||= Dynameister::Client.new
      end

      def expanded(assigned = nil)
        assigned = (assigned || {}).symbolize_keys
        {}.tap do |hash|
          self.attributes.each do |attribute, _|
            hash[attribute] = assigned[attribute]
          end
        end
      end

      def create_table
        client.create_table(table_name: table_name) unless table_exists?
      end

      def table_exists?
        client.table_names.include? table_name
      end

      def create(attrs = {})
        new(attrs).tap(&:save)
      end

      def find_by(hash_key:)
        retrieved = client.get_item(table_name: table_name, hash_key: hash_key)
        if retrieved.empty?
          nil
        else
          new(retrieved.item)
        end
      end

    end

    def initialize(attrs = {})
      @attributes ||= {}
      load attrs
    end

    def save
      self.class.create_table
      persist
    end

    #TODO: Add support for non-default hash key
    def delete
      client.delete_item(table_name: table_name, hash_key: { id: self.id })
    end

    private

    def load(attributes)
      self.class.expanded(attributes).each do |key, value|
        send "#{key}=", value
      end
    end

    def client
      self.class.client
    end

    def table_name
      self.class.table_name
    end

    #TODO: fix id and hash_key stuff
    def persist
      self.id = SecureRandom.uuid unless self.id
      client.put_item(table_name: table_name, item: self.attributes)
      self
    end

  end
end
