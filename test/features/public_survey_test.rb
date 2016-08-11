require 'test_helper'
class PublicSurveyTest < Capybara::Rails::TestCase
  before do
    Capybara.default_driver = :webkit
  end
  
  describe 'pro/con' do
    before do
      @s = surveys(:published_survey)
      @base_url = '/surveys/public_show/' + @s.public_link
      visit @base_url
    end

    it 'gets to thank you screen' do
      # order = procon, radio, new idea, budget, ranking
      refute page.has_text? 'Thank you'
      sleep 1

      page.find('#current-question').click
      assert_operator page.all('#other-sections .clickable', visible: true).count, :>, 0
      page.find('body').click
      assert_equal 0, page.all('#other-sections .clickable', visible: true).count

      (1 + @s.question_assignments.count).times do
        page.find('#go-right').click
      end

      # Can use summary clicks - go back one screen - ranking
      page.all('.clickable').last.click
      assert page.has_content? 'ranking'
      # return to summary
      page.find('#go-right').click
      
      page.find('#go-right').click
      assert_match /thank you/i, page.text

      # It won't let you restart the survey
      visit @base_url
      assert page.has_text? 'Thank you'
    end
  end
end
