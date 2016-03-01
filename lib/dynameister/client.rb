require "aws-sdk"

module Dynameister

  class Client

    def create_table(table_name:, hash_key:, options: {})
      options[:hash_key]       ||= hash_key
      options[:read_capacity]  ||= Dynameister.read_capacity
      options[:write_capacity] ||= Dynameister.write_capacity
      options[:local_indexes]  ||= []
      options[:global_indexes] ||= []

      table_definition = Dynameister::TableDefinition.new(table_name, options).to_h
      table            = aws_resource.create_table(table_definition)

      sleep 0.5 while table.reload.table_status == "CREATING"

      table
    end

    def delete_table(table_name:)
      table = Aws::DynamoDB::Table.new(table_name, client: aws_client)
      table.delete
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException
      false
    else
      begin
        sleep 0.5 while table.reload.table_status == "DELETING"
      rescue Aws::DynamoDB::Errors::ResourceNotFoundException
        true
      end
    end

    def get_item(table_name:, key:)
      serialized = Dynameister::Serializers::BaseItemSerializer.new(
        table_name: table_name, key: key)

      aws_client.get_item(serialized.to_h)
    end

    def put_item(table_name:, item:)
      serialized = Dynameister::Serializers::PutItemSerializer.new(
        table_name: table_name,
        item:       item)

      aws_client.put_item(serialized.to_h)
    end

    def delete_item(table_name:, key:)
      serialized = Dynameister::Serializers::BaseItemSerializer.new(
        table_name: table_name, key: key)

      aws_client.delete_item(serialized.to_h)
    end

    def scan_table(options)
      aws_client.scan(options)
    end

    def query_table(options)
      aws_client.query(options)
    end

    def describe_table(table_name:)
      aws_client.describe_table(table_name: table_name)
    end

    def aws_client
      @@aws_client ||= Aws::DynamoDB::Client.new(aws_client_options)
    end

    def aws_resource
      @@aws_resource ||= Aws::DynamoDB::Resource.new(client: aws_client)
    end

    def table_names
      aws_client.list_tables.table_names
    end

    private

    def aws_client_options
      {
        endpoint:    Dynameister.endpoint,
        region:      Dynameister.region,
        credentials: Dynameister.credentials
      }.delete_if { |_, v| v.nil? }
    end

  end

end
