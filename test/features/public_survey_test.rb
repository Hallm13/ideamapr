require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase
  before do
    Capybara.default_driver = :selenium
  end
  
  describe 'pro/con' do
    before do
      @s = surveys(:published_survey)
      @base_url = '/surveys/public_show/' + @s.public_link
      visit @base_url
    end

    it 'cycles through questions' do
      page.find('#go-right').click
      assert page.has_content? 'pre5 '
      assert_equal 1, page.all('.idea-box', visible: true).size
    end

    it 'gets to thank you screen' do
      refute page.has_text? 'Thank you'

      page.find('#go-right').click
      page.find('#go-right').click
      page.find('#go-right').click
      page.find('#go-right').click

      assert page.has_text? 'Thank you'

      # It won't let you restart the survey
      visit @base_url
      assert page.has_text? 'Thank you'
    end
  end
end
