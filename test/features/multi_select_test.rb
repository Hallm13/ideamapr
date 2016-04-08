require 'test_helper'
class MultiSelectTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    visit '/survey_questions?for_survey=' + (@id = surveys(:survey_1).id).to_s
  end

  test 'selection' do
    assert page.assert_selector(".selector-control", count: SurveyQuestion.count)

    elt = page.all('.selector-control')[0]
    id = elt['data-target-id']

    elt.click
    assert elt.find('input:checked')
    
    page.find('#add-multi-select').click

    uri = URI.parse(current_url)
    expect = "#{uri.path}?#{uri.query}"
    assert_equal "/surveys/#{@id}/edit?" + "survey[qns][]=#{id}", expect
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
