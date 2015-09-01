require "aws-sdk"

module Dynameister

  class Client

    def initialize(attribute_casters: {})
      @attribute_casters = attribute_casters
    end

    def create_table(table_name:, hash_key: :id, options: {})
      options[:hash_key] ||= { hash_key.to_sym => :string }
      options[:read_capacity] ||= Dynameister.read_capacity
      options[:write_capacity] ||= Dynameister.write_capacity
      options[:local_indexes] ||= []
      options[:global_indexes] ||= []

      table_definition = Dynameister::TableDefinition.new(table_name, options).to_h
      table            = aws_resource.create_table(table_definition)

      sleep 0.5 while table.table_status == 'CREATING'

      table
    end

    def delete_table(table_name:)
      table = aws_client.delete_table(table_name: table_name)
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException
      false
    else
      sleep 0.5 while table.table_description.table_status == 'DELETING'
      true
    end

    def get_item(table_name:, hash_key:, range_key: nil)
      serialized = Dynameister::Serializers::GetItemSerializer.new(
        table_name: table_name,
        hash_key:   hash_key,
        range_key:  range_key)

      deserialize_attribute_values(aws_client.get_item(serialized.to_h))
    end

    def put_item(table_name:, item:)
      serialized = Dynameister::Serializers::PutItemSerializer.new(
        table_name: table_name,
        item:       serialize_attribute_values(item))

      aws_client.put_item(serialized.to_h)
    end

    def delete_item(table_name:, hash_key:, range_key: nil)
      serialized = Dynameister::Serializers::DeleteItemSerializer.new(
        table_name: table_name,
        hash_key:   hash_key,
        range_key:  range_key)

      aws_client.delete_item(serialized.to_h)
    end

    def scan_table(options)
      aws_client.scan(options)
    end

    def query_table(options)
      aws_client.query(options)
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
      if %w(ci test).include?(ENV['DYNAMEISTER_ENV'])
        { endpoint: ENV['DYNAMEISTER_ENDPOINT'] }
      else
        {}
      end
    end

    def deserialize_attribute_values(item)
      return item unless item.respond_to?(:item) && item.item.present?

      item.item = apply_attribute_casting(item.item, :deserialize)
      item
    end

    def serialize_attribute_values(item)
      apply_attribute_casting(item, :serialize)
    end

    def apply_attribute_casting(item, operation)
      item = item.with_indifferent_access
      @attribute_casters.each_pair do |attr_name, type_caster|
        item[attr_name] = type_caster.send(operation, item[attr_name])
      end

      item
    end

  end

end
