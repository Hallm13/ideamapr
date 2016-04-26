require 'test_helper'
class SurveyAddBehaviorTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    visit "/surveys/#{surveys(:survey_1).id}/edit"
  end

  test 'go to select screen' do
    page.find('#select-contained').click
    assert page.has_css?('.fa.fa-check.active-icon')
  end

  test 'save survey' do
    sq_1_id = survey_questions(:sq_1).id
    
    page.find('#select-contained').click
    page.find('.fa.fa-check.active-icon' + "[data-action-target='#{sq_1_id}']").click
    page.find('#add-multi-select').click
    fill_in 'survey_introduction', with: 'hello world'
    click_on 'Save'

    assert current_path, survey_path(surveys(:survey_1))

    # Survey 1 already has a question assigned to it.
    assert page.has_css?('.question-box', count: 2)
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
