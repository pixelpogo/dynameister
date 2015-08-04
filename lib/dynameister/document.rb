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

      def undump(attrs = nil)
        attrs = (attrs || {}).symbolize_keys
        Hash.new.tap do |hash|
          self.attributes.each do |attribute, options|
            hash[attribute] = undump_field(attrs[attribute], options)
          end
          attrs.each { |attribute, value| hash[attribute] = value unless hash.has_key? attribute }
        end
      end

      def create_table
        client.create_table(table_name: table_name) unless table_exists?
      end

      def table_exists?
        client.table_names.include? table_name
      end

      def undump_field(value, options)

        return if value.nil?

        case options[:type]
        when :string
          value.to_s
        when :integer
          value.to_i
        when :boolean
          value
        end
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

    def delete
      client.delete_item(table_name: table_name, hash_key: { id: self.id })
    end

    private

    def load(attributes)
      self.class.undump(attributes).each do |key, value|
        send "#{key}=", value
      end
    end

    def client
      self.class.client
    end

    def table_name
      self.class.table_name
    end

    def persist
      self.id = SecureRandom.uuid
      client.put_item(table_name: table_name, item: self.attributes)
      self
    end

  end
end
