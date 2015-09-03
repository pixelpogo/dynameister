module Dynameister

  class Collection

    class Response

      attr_accessor :count, :entities, :last_evaluated_key

      def initialize
        @count    = 0
        @entities = []
      end

    end

    def deserialize_response(response, previous_response = nil)
      Response.new.tap do |current_response|
        current_response = previous_response if previous_response
        current_response.count += response.count

        if response.items
          current_response.entities += response.items.map(&:symbolize_keys)
        end
      end
    end

  end

end
