require 'test_helper'
class SurveyEditTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :selenium
    login_as admins(:admin_1), scope: :admin
  end
  
  describe 'save questions multiple times' do
    it 'works' do
      visit "/surveys/new"
      sleep 1
      assert_equal SurveyQuestion.count, page.all('.square-button.green').size
    end
  end
end
