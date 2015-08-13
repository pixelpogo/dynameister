module Dynameister
  module Document
    extend ActiveSupport::Concern

    include Dynameister::Fields
    include Dynameister::Finders
    include Dynameister::Indexes
    include Dynameister::Persistence

    module ClassMethods

      def expanded(assigned = nil)
        assigned = (assigned || {}).symbolize_keys
        self.attributes.inject({}) do |hash, (attribute, _)|
          hash[attribute] = assigned[attribute]
          hash
        end
      end

    end

    def initialize(attrs = {})
      @attributes = {}
      load attrs
    end

    private

    def load(attributes)
      self.class.expanded(attributes).each do |key, value|
        send "#{key}=", value
      end
    end

  end
end
