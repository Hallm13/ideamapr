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

    it 'correctly edits ideas' do
      # order = procon, radio, new idea, budget, ranking
      sleep 1
      page.find('#go-right').click
      page.find('#go-right').click
      page.find('#go-right').click

      fill_new_idea '1st', 'desc 1'
      fill_new_idea '2nd', 'desc 2'

      # Edit 2nd idea
      idea_2_title = page.all('.new-idea')[1].find('.idea-title')
      idea_2_title.click
      idea_2_title.send_keys ' hello'
      # Cause blur
      page.find('#new_idea_title').click
      # bug. fixed.
      refute_equal '2nd hello', page.all('.new-idea')[0].find('.idea-title').text
    end
  end

  private
  def fill_new_idea(title, desc)
    fill_in 'new_idea_title', with: title
    fill_in 'new_idea_description', with: desc
    page.find('#add-idea').click
  end
end
