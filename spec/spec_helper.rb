require 'codeclimate_helper'
require 'simplecov'

require "active_support"
require "active_support/core_ext"
require "pry"
require "rspec"
require "rspec/its"

require "dynameister"

Dynameister.configure do |config|
  config.endpoint (ENV['DYNAMEISTER_ENDPOINT'] || "http://localhost:8000")
  config.region "dynameister-test"
  config.credentials Aws::Credentials.new( "access_key_id", "secret_access_key","session_token")
end

Dir[File.join(File.dirname(__FILE__), "/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end
