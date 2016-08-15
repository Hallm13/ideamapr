require 'test_helper'
class FancyRankingBoxTest < Capybara::Rails::TestCase
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

      (1 + @s.question_assignments.count - 1).times do
        page.find('#go-right').click
      end

      # seeing last qn - ranking
      assert_equal 1, page.all('.ranking-prompt').size
      # return to summary
      page.all('.ranking-sign.down').first.click
      assert_equal 0, page.all('.ranking-prompt').size
    end
  end
end
