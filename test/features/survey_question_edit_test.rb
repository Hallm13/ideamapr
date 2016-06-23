require 'test_helper'
class SurveyQuestionEditTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :selenium
    login_as admins(:admin_1), scope: :admin
  end
  
  describe 'save fields question' do
    it 'can add new ideas' do
      visit "/survey_questions/#{survey_questions(:sq_with_radio_choice).id}/edit"

      page.all('button')[0].click
      ed_boxes = page.all('.editable-text')
      assert_equal 7, ed_boxes.size
      
      ed_boxes.last.click
      ed_boxes.last.send_keys 'field X'
      page.find('#object-save').click

      assert_equal "/survey_questions", page.current_path

      visit survey_question_path(survey_questions(:sq_with_radio_choice))
      assert_match /field X/, page.body
    end
  end
end
