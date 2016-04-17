require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase  
  describe 'pro/con' do
    before do
      Capybara.default_driver = :webkit
      @s = surveys(:published_survey)
      @s.publish
      visit '/survey/public_show/' + @s.public_link
    end

    it 'counts pros and cons' do

      3.times do
        find('.addpro').click
      end
      5.times do
        find('button.addcon').click
      end
      assert_match /3 pros.*5 cons/, page.body
    end
  end
end
