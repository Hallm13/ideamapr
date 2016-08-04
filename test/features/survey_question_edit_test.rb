require 'test_helper'
class SurveyQuestionEditTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :selenium
    login_as admins(:admin_1), scope: :admin
  end
  describe 'search field works' do
    it 'can add new ideas' do
      visit "/survey_questions/#{survey_questions(:sq_1).id}/edit"
      click_on 'add-component'
      assert page.has_css?('.idea-card-row', visible: true)
      fill_in 'idea-search', with: 'ZZZ'
      refute page.has_css?('#unassigned-ideas .idea-card-row', visible: true)
    end
  end
    
  describe 'delete button works' do
    it 'can add new ideas' do
      visit "/survey_questions/#{survey_questions(:sq_with_radio_choice).id}/edit"
      sleep 1
      xs = page.all('.detail-row')
      xs.last.hover
      xs = page.all('.detail-row #out')
      xs.last.click

      ed_boxes = page.all('.editable-text')
      assert_equal 5, ed_boxes.size
    end
  end
  describe 'save fields question' do
    it 'can add new ideas' do
      visit "/survey_questions/#{survey_questions(:sq_with_radio_choice).id}/edit"
      sleep 1
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
