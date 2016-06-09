require 'test_helper'
class FormsBehaviorTest < Capybara::Rails::TestCase
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    visit '/ideas/new'
  end

  test 'turning green' do
    elt = page.all('.validated-box')[0]
    elt.set 'abcdefghijklmno'
    assert_match /background-color: rgb.\d+, \d+, \d+/, page.all('.validated-box')[0]['style']
    elt.set 'abc'
    assert_match /rgb.255..255..255/, page.all('.validated-box')[0]['style']
  end

  test 'helper text' do
    assert page.has_css?('.help-text', visible: false)
    elt = page.all('.builder-after')[0]
    elt.click
    assert page.has_css?('.help-text', visible: true)
  end

  test 'showing budget screen' do
    visit '/survey_questions/new'
    refute page.has_content? 'Set Budget'

    page.find('#survey_question_question_type').select 'Budgeting'
    assert page.has_content? 'Perform a budgeting'
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
