require 'test_helper'

class QuestionDetailsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#index' do
    it 'works' do
      xhr :get, :index, for_survey_question: survey_questions(:sq_with_radio_choice).id
      b = JSON.parse(response.body)
      
      assert_equal 6, b.size
      assert_equal 1, b[1]['component_rank']
    end
  end
end
