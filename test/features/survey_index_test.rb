require 'test_helper'

class SurveyIndexTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1)
  end
  
  test 'index page Backbone' do
    visit '/surveys'
    sleep 1
    assert_equal Survey.count, page.all('#survey-list-app .row').count
  end
end
