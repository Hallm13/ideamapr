require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase
  before do
    Capybara.default_driver = :webkit
  end
  
  describe 'pro/con' do
    before do
      @s = surveys(:published_survey)
      @base_url = '/survey/public_show/' + @s.public_link
      visit @base_url
    end

    it 'cycles through questions' do
      page.find('#go-right').click
      assert page.has_content? 'pre5 '
      assert page.has_css?('.idea-title', visible: true, count: 1)
    end

    it 'gets to thank you screen' do
      page.find('#go-right').click
      page.find('#go-right').click
      assert page.has_content? 'thank you!'
    end
  end
end
