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

    end

    def initialize(attributes={})
      load attributes
    end

    def save
      client.create_table(table_name: self.class.table_name) unless table_exists?
    end

    private

    def load(attributes)
      attributes.each do |key, value|
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
