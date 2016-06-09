require 'test_helper'

class QuestionDetailsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#index' do
    it 'works' do
      xhr :get, :index, for_question: survey_questions(:sq_with_radio_choice).id
      assert_equal 6, JSON.parse(response.body).size
    end
  end
end
