module Dynameister

  module Scan
    extend ActiveSupport::Concern

    module ClassMethods

      def scan(options = {})
        response = self.client.scan_table(parameters(options))
        Collection.new(response, self)
      end

      private

      def parameters(options)
        Parameters.new(self, options).to_h
      end

    end
  end

end
