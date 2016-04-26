require 'test_helper'
class TrashButtonTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  
  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
    
    @s = surveys(:survey_1)
    @base_url = "/surveys/#{@s.id}/edit"
  end

  test 'list of questions without dupes' do
    visit @base_url

    assert_equal 1, page.all('.question-box').count
    visit @base_url + "?survey[components][]=#{survey_questions(:sq_1).id}"
    assert_equal 2, page.all('.question-box').count
  end
  test 'list of questions with dupes' do
    visit @base_url + "?survey[components][]=#{survey_questions(:sq_pre_4).id}"
    assert_equal 1, page.all('.question-box').count
  end
  test 'trash button' do
    visit @base_url + "?survey[components][]=#{survey_questions(:sq_1).id}"
    page.find("#qn-box-0").find('.col-xs-2').find('.fa-trash-o').trigger('click')
    visit @base_url + "?survey[components][]=#{survey_questions(:sq_1).id}"
    assert_equal 1, page.all('.question-box').count
  end
  
end
