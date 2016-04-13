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
    page.find('#select-question').click
    assert page.has_css?('.fa.fa-check')
  end

  test 'save survey' do
    page.find('#select-question').click
    page.all('.fa.fa-check')[0].click
    page.find('#add-multi-select').click
    fill_in 'survey_introduction', with: 'hello world'
    click_on 'Save'

    assert current_path, survey_path(surveys(:survey_1))
    assert page.has_content? '2 Questions'
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
