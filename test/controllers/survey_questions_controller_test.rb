require 'test_helper'

class SurveyQuestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#new' do
    it 'works' do
      get :new
      assert_template :new
    end
  end

  describe '#edit' do
    it 'works' do
      get :edit, step_command: :multi_idea_add, id: survey_questions(:sq_blank).id

      assert_template :edit
      assert assigns(:payload)

      assert_select('option') do |elts|
        assert_equal SurveyQuestion::QuestionType.multi_idea_commands.size, elts.size
      end
    end
  end
  
  describe 'new and create loop' do
    it 'works with correct params' do
      get :new

      assert_select 'input[name=\'survey_question[title]\']'

      assert_difference('SurveyQuestion.count', 1) do
        post :create, survey_question: {title: 'this is a question title'}
      end
      assert_redirected_to survey_questions_path
    end
  end
  
  describe 'authorization' do
    it 'is required' do
      sign_out admins(:admin_1)
      get :new
      assert_redirected_to new_admin_session_path
    end
  end
end
