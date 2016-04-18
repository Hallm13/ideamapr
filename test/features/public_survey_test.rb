require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase  
  describe 'pro/con' do
    before do
      Capybara.default_driver = :webkit
      @s = surveys(:published_survey)
      @s.publish
      visit '/survey/public_show/' + @s.public_link
    end

    it 'shows all ideas' do
      page.find_all '.page-title'
      assert page.has_css?('.idea-title', count: @s.survey_questions.first.ideas.count)
    end
  end
end
