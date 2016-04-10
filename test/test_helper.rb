require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'mocha/mini_test'
require 'webmock/minitest'

require 'minitest/rails/capybara'
require 'capybara/webkit'

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }
WebMock.disable_net_connect!(:allow_localhost => true)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  include FixtureFiles
  fixtures :all
end

class ActionController::TestCase
  # Let controller test cases open files
  include FixtureFiles

  # Some controllers will need Devise
  include Devise::TestHelpers
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread. Needed for login_as
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
