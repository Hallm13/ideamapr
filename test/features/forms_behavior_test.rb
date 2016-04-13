require 'test_helper'
class FormsBehaviorTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    visit '/surveys/0/edit'
  end

  test 'turning green' do
    elt = page.all('.watched-box')[0]
    elt.set 'abcdefghijklmno'
    assert_match /background-color: rgb.\d+, \d+, \d+/, page.all('.builder-before')[0]['style']
    elt.set 'abc'
    assert_match /white/, page.all('.builder-before')[0]['style']
  end

  test 'helper text' do
    assert page.has_css?('.help-text', visible: false)
    elt = page.all('.builder-after')[0]
    elt.click
    assert page.has_css?('.help-text', visible: true)
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
