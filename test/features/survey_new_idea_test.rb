require 'test_helper'
class SurveyNewIdeaTest < Capybara::Rails::TestCase
  before do
    Capybara.default_driver = :webkit
  end
  
  describe 'pro/con' do
    before do
      @s = surveys(:published_survey_2)
      @base_url = '/surveys/public_show/' + @s.public_link
      visit @base_url
    end

    it 'gets to thank you screen' do
      # order = new idea
      page.find('#go-right').click
      page.fill_in 'new_idea_title', with: 'i like this idea'
      page.fill_in 'new_idea_description', with: 'i like this idea it is a great idea huuuuge'
      page.find('.btn').click
      assert_equal 1, page.all('.idea-row').size
    end
  end
end
