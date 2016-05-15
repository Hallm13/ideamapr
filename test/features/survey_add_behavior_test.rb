require 'test_helper'
class SurveyAddBehaviorTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    #visit edit_survey_path(surveys(:survey_1))
  end

  def teardown
    Capybara.default_driver = :rack_test
  end
end
