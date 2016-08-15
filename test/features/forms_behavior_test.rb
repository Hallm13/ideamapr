require 'test_helper'
class FormsBehaviorTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    visit '/ideas/new'
  end

  test 'turning green' do
    elt = page.all('.validated-box')[0]
    assert_match /rgb.255..255..255/, page.all('.validated-box')[0]['style']
    
    elt.set 'abcdefghijklmno'
    assert_match /background-color: rgb.223, \d+, \d+/, page.all('.validated-box')[0]['style']
    elt.set '  '

    assert_match /rgb.255..255..255/, page.all('.validated-box')[0]['style']
  end

  test 'showing budget screen' do
    visit '/survey_questions/new'
    refute page.has_content? 'Set Budget'

    page.find('#survey_question_question_type').select 'Budgeting'
    assert page.has_content? 'Perform a budgeting'
  end
  
  test 'create survey' do
    visit '/surveys/new'
    fill_in 'survey_title', with: 'long long title filled'
    fill_in 'survey_introduction', with: 'long long introduction also filled'
    fill_in 'survey_thankyou_note', with: 'long long thank you note now filled'

    click_on 'object-save'
    assert_equal '/surveys', current_path 
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
