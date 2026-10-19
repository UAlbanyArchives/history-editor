ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Never talk to a real Solr server from the test suite.
SolrService.singleton_class.prepend(Module.new do
  def add(*); end
  def commit(*); end
  def delete_by_id(*); end
end)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
