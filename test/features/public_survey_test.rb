require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase  
  describe 'pro/con' do
    before do
      Capybara.default_driver = :webkit
      @s = surveys(:published_survey)
      @s.publish
      @base_url = '/survey/public_show/' + @s.public_link + "?step="
    end

    it 'shows pro/con question' do
      visit @base_url + '1'
      page.find_all '.page-title'
      assert page.has_content? 'Add Pro'
      assert page.has_css?('.idea-title', count: survey_questions(:sq_pre_4).ideas.count)
    end

    it 'shows pro/con question' do
      visit @base_url + '2'
      page.find_all '.page-title'
      assert page.has_content? 'has rank'
    end    
  end
end
