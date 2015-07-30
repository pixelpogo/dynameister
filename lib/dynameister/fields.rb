module Dynameister
  module Fields
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes

      self.attributes = {}

      field :id # default primary key
    end

    module ClassMethods

      def field(name, type = :string, options = {})
        named = name.to_s
        self.attributes = attributes.merge(name => {type: type}.merge(options))

        define_method(named) { read_attribute(named) }
        define_method("#{named}?") { !read_attribute(named).nil? }
        define_method("#{named}=") {|value| write_attribute(named, value) }
      end

    end
  end
end
