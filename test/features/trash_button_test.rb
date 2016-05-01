require 'test_helper'
class TrashButtonTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    
    @s = surveys(:survey_1)
    @base_url = "/surveys/#{@s.id}/edit"

    @sq = survey_questions(:sq_1)
    @sq_base_url = "/survey_questions/#{@sq.id}/edit"
  end

  def added_survey(qn_key)
    @base_url + "?survey[components][]=#{survey_questions(qn_key).id}"
  end
  
  test 'list of questions without dupes' do
    visit @base_url

    assert_equal 1, page.all('.survey_question-box').count
    visit added_survey(:sq_1) 
    assert_equal 2, page.all('.survey_question-box').count
  end
  test 'list of questions with dupes' do
    x = added_survey(:sq_pre_4)
    visit x
    assert_equal 1, page.all('.survey_question-box').count
  end
  test 'trash button for survey' do
    visit @base_url
    assert_equal 1, page.all('.survey_question-box').count
    page.find("#qn-box-0").find('.fa-trash-o').trigger('click')
    visit @base_url
    assert_equal 0, page.all('.survey_question-box').count
  end
  test 'trash button for survey question' do
    visit @sq_base_url
    assert_equal 1, page.all('.idea-box').count
    page.find("#idea-box-0").find('.col-xs-2').find('.fa-trash-o').trigger('click')
    visit @sq_base_url

    assert_equal 0, page.all('.idea-box').count
  end  
end
