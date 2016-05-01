require 'test_helper'
class MultiSelectTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
  end

  test 'selection of questions for survey' do
    visit '/survey_questions?for_survey=' + (@id = surveys(:survey_1).id).to_s
    assert (SurveyQuestion.count - surveys(:survey_1).survey_questions.count), page.all(".fa-check").count

    elt = page.all('.fa.fa-check')[0]
    id = elt['data-action-target']

    elt.click
    page.find('#add-multi-select').click

    uri = URI.parse(current_url)
    expect = "#{uri.path}?#{uri.query}"
    assert_equal "/surveys/#{@id}/edit?" + "survey[components][]=#{id}", expect
  end
  
  test 'selection of ideas for question' do
    visit '/ideas?for_survey_question=' + (@id = survey_questions(:sq_1).id).to_s
    assert_equal Idea.count - survey_questions(:sq_1).ideas.count, page.all(".fa-check").count

    elt = page.all('.fa.fa-check')[0]
    id = elt['data-action-target']

    elt.click
    page.find('#add-multi-select').click

    uri = URI.parse(current_url)
    expect = "#{uri.path}?#{uri.query}"
    assert_equal "/survey_questions/#{@id}/edit?" + "survey_question[components][]=#{id}", expect
  end
  
  def teardown
    Capybara.default_driver = :rack_test
  end
end
