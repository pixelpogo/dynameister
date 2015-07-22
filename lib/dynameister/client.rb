require_relative "table_definition"

require "aws-sdk"

module Dynameister

  class Client

    def create_table(table_name:, hash_key: :id, options: {})
      options[:hash_key]       ||= { hash_key.to_sym => :string }
      options[:read_capacity]  ||= Dynameister.read_capacity
      options[:write_capacity] ||= Dynameister.write_capacity
      options[:local_indexes]  ||= {}

      table_definition = Dynameister::TableDefinition.new(table_name, options).to_h
      table            = aws_resource.create_table(table_definition)

      sleep 0.5 while table.table_status == 'CREATING'

      table
    end

    def delete_table(table_name:)
      begin
        table = aws_client.delete_table(table_name: table_name)
      rescue Aws::DynamoDB::Errors::ResourceNotFoundException
        false
      else
        sleep 0.5 while table.table_description.table_status == 'DELETING'
        true
      end
    end

    def aws_client
      @@aws_client ||= Aws::DynamoDB::Client.new(aws_client_options)
    end

    def aws_resource
      @@aws_resource ||= Aws::DynamoDB::Resource.new(client: aws_client)
    end

    private

    def aws_client_options
      # TODO: Decide how to handle the configuration of endpoint and region
      #       for development and production.
      true ? { endpoint: ENV['DYNAMEISTER_ENDPOINT'] } : {}
    end

  end

end
