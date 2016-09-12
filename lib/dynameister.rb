require "active_support"
require "active_support/core_ext"
require "dynameister/config"
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

  extend self

  def configure
    block_given? ? yield(Dynameister::Config) : Dynameister::Config
  end

end
