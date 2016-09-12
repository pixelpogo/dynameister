require "dynameister/config/options"

module Dynameister

  module Config

    extend self
    extend Options

    option :read_capacity, default: 1
    option :write_capacity, default: 1
    option :region
    option :endpoint
    option :credentials

  end

end
