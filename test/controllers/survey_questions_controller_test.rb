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

      get :edit, id: survey_questions(:sq_budget_type).id
      assert_template :edit      
      get :edit, id: survey_questions(:sq_text_fields).id
      assert_template :edit      
    end
  end
  
  describe 'new and create loop' do
    it 'works with correct params' do
      get :new
      assert_select 'input[name=\'survey_question[title]\']'

      assert_difference('SurveyQuestion.count', 1) do
        post :create, {survey_question: {title: 'this is a question title', question_type: 1}}
      end

      assert_equal I18n.t(SurveyQuestion::QuestionType.prompts[1]), SurveyQuestion.last.question_prompt
      assert_redirected_to survey_questions_path
    end
    
    it 'works to add ideas to existing sq' do
      sq = survey_questions(:sq_1)

      idea_sz = sq.ideas.count # shd be 1, idea_3
      refute_difference('SurveyQuestion.count') do 
        put(:update, {id: sq.id,
                      survey_question: {title: 'this is a new test title'},
                      question_details: ({question_type: sq.question_type,
                                          'details' => [{id: ideas(:idea_1).id, 'component_rank' => 0},
                                                    {id: ideas(:idea_3).id, 'component_rank' => 1}]}).to_json})
      end
      assert_equal idea_sz + 1, sq.ideas.count
      assert_redirected_to survey_questions_url
    end
  end
  describe '#update' do
    it 'can refresh details for non-idea question type' do
      sq = survey_questions(:sq_with_radio_choice)
      old_id = sq.question_detail.id
      put(:update, {id: sq.id, survey_question: {title: 'this is a new test title'},
                    question_details: ({'details' => [{'text' => 'a1', 'component_rank' => 1},
                                        {'text' => 'a2', 'component_rank' => 0}]}).to_json})

      assert sq.reload.question_detail.present?

      # We deleted the old detail and created a new record.
      refute_equal old_id, sq.question_detail.id

      # We sorted.
      assert_equal 'a2', sq.question_detail.details_list[0]['text']
    end

    it 'can add budget for budget idea type' do
      sq = survey_questions(:sq_budget_type)

      # idea_1 is already assigned without a budget; idea_2 will now be added
      model = "\\'SurveyQuestion\\'"
      assert_difference("IdeaAssignment.where('groupable_id = #{sq.id} and groupable_type=#{model}').count", 1) do
        put :update, {id: sq.id, survey_question: {title: 'a new title now for budget qn',
                                                   question_type: SurveyQuestion::QuestionType::BUDGETING},
                      question_details: ({details: [{'id' => ideas(:idea_1).id, 'budget' => '42.42', 'component_rank' => 1},
                                          {'id' => ideas(:idea_2).id, 'budget' => '84.84', 'component_rank' => 0}
                                         ]}).to_json}
        
      end

      # idea_1 was pushed to the bottom of the assignment.
      assert_equal ideas(:idea_1).id, IdeaAssignment.order(ordering: :desc).first.idea_id
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

    it 'sets up all questions as unassigned for new surveys' do
      xhr :get, :index, for_survey: ''
      b = JSON.parse(response.body)
      assert_equal SurveyQuestion.count, b.size
      assert_equal SurveyQuestion.count, b.select { |i| !i['is_assigned'] }.size
    end

    it 'does not require auth when the survey is public and the request is XHR' do
      sign_out :admin
      xhr :get, :index, for_survey: surveys(:published_survey).public_link
      b = JSON.parse(response.body)
      
      assert_equal surveys(:published_survey).survey_questions.count, b.size
      assert_equal 0, b.select { |i| !i['is_assigned'] }.size
    end
    
    it 'separates questions by assignment for private surveys when the request is XHR' do
      xhr :get, :index, for_survey: surveys(:survey_1)
      b = JSON.parse(response.body)
      assert_equal SurveyQuestion.count, b.size
      assert_equal survey_questions(:sq_pre_5_procon).id, b[0]['id']
      assert_equal SurveyQuestion.count - surveys(:survey_1).survey_questions.count,
                   b.select { |i| !i['is_assigned'] }.size
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
