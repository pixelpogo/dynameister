require "dynameister/client"
require "dynameister/item_serializer"
require "dynameister/version"

module Dynameister

  # The default read capacity set for new tables.
  @@read_capacity = 1

  def self.read_capacity(read_capacity = nil)
    if read_capacity
      @@read_capacity = read_capacity
    else
      @@read_capacity
    end
  end

  # The default write capacity set for new tables.
  @@write_capacity = 1

  def self.write_capacity(write_capacity = nil)
    if write_capacity
      @@write_capacity = write_capacity
    else
      @@write_capacity
    end
  end

  def self.configure
    yield self
  end

end
