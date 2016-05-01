require 'test_helper'

class SurveyIndexTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1)
  end
  
  test 'index page Backbone' do
    visit '/surveys'
    page.all('.cell-1')
    assert_equal 4*Survey.count, page.all('.cell-1').count
  end
end
