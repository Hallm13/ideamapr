require 'test_helper'

class SurveyQuestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#edit' do
    it 'works plainly without ideas' do
      get :edit, id: survey_questions(:sq_blank).id
      assert_template :edit

      assert_select('option', count: 0)
    end
  end
  
  describe 'new and create loop' do
    it 'works with correct params' do
      get :new
      assert_select 'input[name=\'survey_question[title]\']'

      assert_difference('SurveyQuestion.count', 1) do
        post :create, {survey_question: {title: 'this is a question title', question_type: 1}}
      end

      assert_match /rank these ideas/i, SurveyQuestion.last.question_prompt
      assert_redirected_to survey_question_path(SurveyQuestion.last)
    end
    
    it 'works to add ideas to existing sq' do
      sq = survey_questions(:sq_1)

      idea_sz = sq.ideas.count # shd be 1, idea_3
      refute_difference('SurveyQuestion.count') do 
        put(:update, {id: sq.id,
                      survey_question: {title: 'this is a new test title'},
                      question_details: ({details: ([{id: ideas(:idea_1).id}, {id: ideas(:idea_3).id}])}).to_json})
      end
      assert_equal idea_sz + 1, sq.ideas.count
      assert_redirected_to survey_question_url(sq)
    end

    it 'can refresh question details' do
      sq = survey_questions(:sq_with_radio_choice)
      old_id = sq.question_detail.id
      put(:update, {id: sq.id, survey_question: {title: 'this is a new test title'},
                    question_details: ({details: ['1', 'a']}).to_json})

      assert sq.reload.question_detail.present?
      refute_equal old_id, sq.question_detail.id
    end
  end

  describe "#index" do
    it "shows all survey qns with no parameters" do
      get :index
      assert_select('.question-row', SurveyQuestion.count)
      assert_equal :survey_questions, assigns(:navbar_active_section)
    end
    
    it "shows all survey qns with empty for_survey" do
      get :index, for_survey: ''
      assert_select('.question-row', SurveyQuestion.count)
      assert_equal :survey_questions, assigns(:navbar_active_section)
    end

    it 'does not require auth when the survey is public and the request is XHR' do
      sign_out :admin
      xhr :get, :index, for_survey: surveys(:published_survey).public_link
      assert_equal surveys(:published_survey).survey_questions.count, JSON.parse(response.body).size
    end

    it "activates selection when asked" do
      get :index, {for_survey: surveys(:survey_1).id}
      refute_nil assigns(:survey)
      assert_select('.question-row', SurveyQuestion.count)
    end
  end
  
  describe 'errors' do
    it 'authorization is required' do
      sign_out admins(:admin_1)
      get :edit, {id: 0, step_command: :idea_add}
      assert_redirected_to new_admin_session_path
    end

    it 'model validation are required' do
      post :create, {survey_question: {title: 'shor'}}
      assert_template :new

      put :update, {id: survey_questions(:sq_1), survey_question: {title: 'shor'}}
      assert_template :edit
    end

    it 'valid parameters are required' do
      get :edit, {id: -1}
      assert_redirected_to '/404.html'
    end
  end
end
