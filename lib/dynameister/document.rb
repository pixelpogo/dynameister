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

      def undump( attrs = nil)
        attrs = (attrs || {}).symbolize_keys
        Hash.new.tap do |hash|
          self.attributes.each do |attribute, options|
            hash[attribute] = undump_field(attrs[attribute], options)
          end
          attrs.each {|attribute, value| hash[attribute] = value unless hash.has_key? attribute }
        end
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

    end

    def initialize(attrs = {})
      @attributes ||= {}
      load attrs
    end

    def save
      client.create_table(table_name: self.class.table_name) unless table_exists?
    end

    private

    def load(attributes)
      self.class.undump(attributes).each do |key, value|
        send "#{key}=", value
      end
    end

    def table_exists?
      client.table_names.include? self.class.table_name
    end

    def client
      self.class.client
    end

  end

end
