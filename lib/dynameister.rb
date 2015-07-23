require "active_support"
require "active_support/core_ext"

require "dynameister/client"
require "dynameister/item_serializer"
require "dynameister/version"

module Dynameister

  mattr_accessor :read_capacity do
    1
  end

  mattr_accessor :write_capacity do
    1
  end

  def self.configure
    yield self
  end

end
