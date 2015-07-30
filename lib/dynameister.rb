require "dynameister/client"
require "dynameister/serializers"
require "dynameister/table_definition"
require "dynameister/version"
require "dynameister/document"
require "dynameister/fields"

module Dynameister

  # The default read capacity set for new tables.
  Thread.current[:read_capacity] = 1

  def self.read_capacity(read_capacity = nil)
    if read_capacity
      Thread.current[:read_capacity] = read_capacity
    else
      Thread.current[:read_capacity]
    end
  end

  # The default write capacity set for new tables.
  Thread.current[:write_capacity] = 1

  def self.write_capacity(write_capacity = nil)
    if write_capacity
      Thread.current[:write_capacity] = write_capacity
    else
      Thread.current[:write_capacity]
    end
  end

  def self.configure
    yield self
  end

end
