require 'test_helper'
class ProConParticipantTest < Capybara::Rails::TestCase
  before do
    Capybara.default_driver = :selenium
  end
  
  describe 'pro/con' do
    before do
      @s = surveys(:published_survey)
      @base_url = '/surveys/public_show/' + @s.public_link

      @pro_words = 'my own pro'
      visit @base_url
    end
    it 'gets to thank you screen' do
      # order = procon, radio, new idea, budget
      page.find('#go-right').click
      rows = page.all '.procon.idea-row'
      rows[0].find('#addpro').click
      assert page.has_css? '#save-procon', visible: true

      # clicking on save with no text does nothing
      rows[0].find('#save-procon').click
      refute page.has_content? @pro_words

      # fill in a pro
      rows[0].find('#addpro').click
      rows[0].fill_in 'current-procon', with: @pro_words
      rows[0].find('#save-procon').click
      assert page.has_content? @pro_words      
    end    
  end
end
