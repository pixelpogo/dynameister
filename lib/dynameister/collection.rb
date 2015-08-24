module Dynameister

  class Collection

    class Response
      attr_accessor :count, :entities, :last_evaluated_key

      def initialize
        @count    = 0
        @entities = []
      end
    end

    attr_accessor :client, :table_name

    def initialize(client, table_name)
      @client     = client
      @table_name = table_name.to_s
    end

    def query(options = {}, previous_response = nil)
      response = client.query_table(options.merge(table_name: table_name))
      deserialize_response(response, previous_response)
    end

    def scan(options = {}, previous_response = nil)
      response = client.scan_table(options.merge(table_name: table_name))
      deserialize_response(response, previous_response)
    end

    private

    private

    def deserialize_response(response, previous_response = nil)
      Response.new.tap do |current_response|
        if previous_response
          current_response = previous_response
        end

        current_response.count += response.count
        current_response.entities += response.items.map do |item|
          item.symbolize_keys
        end if response.items
      end
    end

  end

end
