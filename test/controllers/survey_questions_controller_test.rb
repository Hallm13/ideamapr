require 'test_helper'

class SurveyQuestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#edit' do
    it 'works' do
      get :edit, step_command: :idea_add, id: survey_questions(:sq_blank).id

      assert_template :edit
      assert assigns(:payload)

      assert_select('option') do |elts|
        assert_equal SurveyQuestion::QuestionType.option_array.size, elts.size
      end
    end
  end
  
  describe 'new and create loop' do
    it 'works with correct params' do
      get :edit, {id: 0, step_command: :idea_add}

      assert_select 'input[name=\'survey_question[title]\']'

      assert_difference('SurveyQuestion.count', 1) do
        put(:update, {id: 0, survey_question: {title: 'this is a question title'}, step_command: :idea_add})
      end
      assert_redirected_to survey_questions_path
    end
  end

  describe "#index" do
    it "shows all survey qns" do
      get :index
      assert_select('.question-row', SurveyQuestion.count)
    end

    it "activates selection when asked" do
      get :index, {for_survey: surveys(:survey_1).id}
      refute_nil assigns(:survey)
    end
  end
  
  describe 'errors' do
    it 'authorization is required' do
      sign_out admins(:admin_1)
      get :edit, {id: 0, step_command: :idea_add}
      assert_redirected_to new_admin_session_path
    end

    it 'valid parameters are required' do
      put(:update, {id: 0, survey_question: {title: 'shor'}, step_command: :idea_add})
      assert_template :edit
    end
  end
end
