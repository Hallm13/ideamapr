require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase  
  describe 'pro/con' do
    before do
      Capybara.default_driver = :webkit
      @s = surveys(:published_survey)
      @s.publish
      @base_url = '/survey/public_show/' + @s.public_link
      visit @base_url
      page.find_all '.page-title'
    end

    it 'shows pro/con question' do
      sleep 1
      assert page.has_content? 'has rank'
      assert_equal 1, page.all('.idea-title').count
    end

    it 'cycles through questions' do
      page.find('#go-right').click
      assert page.has_content? 'Add Con'
      assert_equal 2, page.all('.idea-title').count
    end    
  end
end
