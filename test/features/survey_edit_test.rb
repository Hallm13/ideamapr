require 'test_helper'
class SurveyEditTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
  end
  
  describe 'save questions multiple times' do
    it 'works' do
      visit "/surveys/new"
      click_on 'Add a Question'
      assert_equal SurveyQuestion.count, page.all('.add-button').size
    end
  end
end
