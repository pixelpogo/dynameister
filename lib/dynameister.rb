require "dynameister/client"
require "dynameister/version"

module Dynameister

  def self.configure(&block)
    @config = Dynameister::Config.new
    yield @config
  end

  def self.config
    @config
  end

  class Config

    def initialize
      @read_capacity  = 1
      @write_capacity = 1
    end

    def read_capacity(read_capacity = nil)
      if read_capacity
        @read_capacity = read_capacity
      else
        @read_capacity
      end
    end

    def write_capacity(write_capacity = nil)
      if write_capacity
        @write_capacity = write_capacity
      else
        @write_capacity
      end
    end

  end

end
