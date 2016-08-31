require 'test_helper'
class ProConParticipantTest < Capybara::Rails::TestCase
  before do
    Capybara.default_driver = :webkit
  end
  
  describe 'pro/con' do
    before do
      @s = surveys(:published_survey)
      @base_url = '/surveys/public_show/' + @s.public_link

      @pro_words = ['my own pro 1', 'another pro 2']
      visit @base_url
    end
    it 'gets to thank you screen' do
      # order = procon, radio, new idea, budget
      page.find('#go-right').click

      idea_rows = page.all '.procon.idea-row'
      idea_rows[0].find('#addpro').click
      assert page.has_css? '#save-procon', visible: true

      # clicking on save with no text does nothing
      idea_rows[0].find('#save-procon').click
      refute page.has_content? @pro_words[0]

      # fill in a pro
      idea_rows[0].find('#addpro').click
      page.fill_in 'current-procon', with: @pro_words[0]
      idea_rows[0].find('#save-procon').click
      assert page.has_content? @pro_words[0]
      
      idea_rows = page.all '.procon.idea-row'
      idea_rows[0].find('#addpro').click
      page.fill_in 'current-procon', with: @pro_words[1]
      idea_rows[0].find('#save-procon').click

      rows = page.all '#pro-column .procon-entry'
      rows[0].find('.x-box').click
      refute page.has_content? @pro_words[0]
      # Add a second pro, use x to remove first one
    end    
  end
end
