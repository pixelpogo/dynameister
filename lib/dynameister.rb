require "active_support"
require "active_support/core_ext"
require "dynameister/client"
require "dynameister/table_definition"
require "dynameister/version"

require "dynameister/data_types"
require "dynameister/fields"
require "dynameister/finders"
require "dynameister/indexes"
require "dynameister/persistence"
require "dynameister/queries/parameters"
require "dynameister/queries"

require "dynameister/document"

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

  # The AWS region for accessing DynamoDB.
  def self.region(region = nil)
    if region
      Thread.current[:region] = region
    else
      Thread.current[:region]
    end
  end

  # The AWS endpoint for accessing DynamoDB.
  def self.endpoint(endpoint = nil)
    if endpoint
      Thread.current[:endpoint] = endpoint
    else
      Thread.current[:endpoint]
    end
  end

  # The AWS credentials for accessing DynamoDB.
  def self.credentials(credentials = nil)
    if credentials
      Thread.current[:credentials] = credentials
    else
      Thread.current[:credentials]
    end
  end

  def self.configure
    yield self
  end

end
