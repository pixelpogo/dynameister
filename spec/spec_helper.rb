require 'codeclimate_helper'
require 'simplecov'

require "active_support"
require "active_support/core_ext"
require "dotenv"
require "pry"
require "rspec"
require "rspec/its"

require "dynameister"

# Load environment-specific settings
ENV['DYNAMEISTER_ENV'] ||= "test"
Dotenv.load(File.join(File.dirname(__FILE__), ".env.#{ENV['DYNAMEISTER_ENV']}"))

Dynameister.endpoint ENV['DYNAMEISTER_ENDPOINT']

Dir[File.join(File.dirname(__FILE__), "/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
