require_relative "table_definition"

require "aws-sdk"

module Dynameister

  class Client

    def create_table(table_name:, hash_key: :id, options: {})
      options[:hash_key]       ||= { hash_key.to_sym => :string }
      options[:read_capacity]  ||= Dynameister.config.read_capacity
      options[:write_capacity] ||= Dynameister.config.write_capacity

      table_definition = Dynameister::TableDefinition.new(table_name, options).to_h
      table            = resource.create_table(table_definition)

      sleep 0.5 while table.table_status == 'CREATING'

      return table
    end

    def delete_table

    end

    private

    def client
      options = true ? { endpoint: ENV['DYNAMEISTER_ENDPOINT'] } : {}

      @@client ||= Aws::DynamoDB::Client.new(options)
    end

    def resource
      @@resource ||= Aws::DynamoDB::Resource.new(client: client)
    end

  end

end
