require 'simplecov'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'mocha/mini_test'
require 'webmock/minitest'

require 'capybara'
require 'capybara/rails'
require 'capybara/webkit'
require 'minitest/rails/capybara'
Capybara.javascript_driver = :webkit

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
  include Devise::Test::ControllerHelpers 
end

Capybara.configure do |config|
  config.javascript_driver = :webkit
end

class Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Shut some CircleCI warnings down
Capybara::Webkit.configure do |config|
  config.allow_url("http://www.gravatar.com/avatar/28e09f805ab4e232218fc8bd12c8fb78?s=30")
  config.allow_url("test.local")
  config.allow_url("https://testbucket.s3.amazonaws.com/dummy_name.png")  
  config.block_url("http://www.google-analytics.com/analytics.js")
  config.ignore_ssl_errors
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread. Needed for login_as
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
Minitest.after_run do
  FileUtils.rm_rf(Dir[Rails.root.join('test', 'fixtures', 'files', 'paperclip')])
end
