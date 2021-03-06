require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  def setup
    sign_in admins(:admin_1)
  end

  describe '#report' do
    it 'works' do
      get :report, id: surveys(:answered_survey).id
      assert_template :report
      assert_match /78\.57/, response.body
    end
    
    it 'handles errors' do
      get :report, id: -1
      assert_redirected_to surveys_path
    end

    it 'shows on edit page' do
      get :edit, id: surveys(:answered_survey).id
      assert_match /78\.57/, response.body
    end      

    it 'shows on index page' do
      get :index
      assert_match /78\.57/, response.body
    end      
  end

  describe '#index' do
    it 'works for admins' do
      get :index
      assert assigns(:surveys)
      assert_equal :surveys, assigns(:navbar_active_section)
    end

    it 'works with tokens' do
      sign_out admins(:admin_1)
      admins(:admin_1).regenerate_auth_token

      xhr :get, :index, token: admins(:admin_1).auth_token
      assert assigns(:surveys)
    end

    it 'generates reports' do
      xhr :get, :index
      b = JSON.parse response.body
      answered_survey = b.select { |r| r['id'] == surveys(:answered_survey).id }.first

      assert answered_survey['report'].keys.include?('individual_answer_count')
      assert_match /\d+/, answered_survey['report']['individual_answer_count'].to_s
    end
  end

  describe '#show: admin' do
    before do
      @survey = surveys(:survey_1)
      @survey.regenerate_public_link
      @survey.save
    end

    it 'works for admin' do
      get :show, id: @survey.id
      assert_template :show

      get :show, id: surveys(:published_survey).id
      assert_template :show
    end

    it 'blocks for unpublished surveys via token' do
      s = surveys(:survey_1)
      s.regenerate_public_link
      get :public_show, public_link: s.public_link
      assert_template :public_show
      assert_select '#survey_status' do |elts|
        assert_equal 1, elts.size
        assert_equal '0', elts[0][:value]
      end
    end
  end

  describe '#show: public' do
    before do
      sign_out admins(:admin_1)
      @public_svy = surveys(:published_survey)
      @public_svy.regenerate_public_link
    end
    
    it 'works with token' do
      assert_difference('Respondent.count', 1) do
        get :public_show, public_link: @public_svy.public_link
      end
      
      assert_template :public_show
      assert_match Respondent.last.cookie_key, response.body
    end
    
    it 'does not work without token' do
      get :public_show, public_link: 'notatoken'
      assert_redirected_to '/404.html'
    end

    it 'works with xhr' do
      xhr :get, :public_show, public_link: @public_svy.public_link
      assert_match /^{/, response.body

      # No errors
      xhr :get, :show, id: surveys(:survey_1)
      xhr :post, :update, id: surveys(:survey_1), survey: ({title: 'hello 123 123 123', status: Survey::SurveyStatus::DRAFT})
      xhr :post, :update, id: surveys(:survey_1), survey: ({title: 'hello 123 123 123', status: -1})
    end
  end
  
  describe '#edit' do
    describe '404 errors' do      
      it 'is triggered by lack of proper id' do
        get :edit, id: -1
        assert_redirected_to '/404.html'
      end
    end

    it 'works for id 0' do
      get :new
      assert_template :new
      assert assigns(:survey_status_select)
      assert_match 'Create', response.body
      assert_select('.builder-box') do |elts|
        assert_equal 7, elts.size
      end
    end      
    
    it 'works for existing survey' do
      get :edit, id: surveys(:survey_1).id

      assert_match /survey 1 title/, response.body
      assert assigns(:survey_status_select)
    end

    it 'shows correct reports' do
      get :edit, id: (s = surveys(:answered_survey)).id
      assert_select ('.survey-summary-data td') do |elts|
        assert_match /#{s.respondents.count}/, elts[0].text
      end
    end
  end
  
  describe '#update' do
    before do
      @s = surveys(:survey_1)
      @idea_list = [ideas(:idea_1), ideas(:idea_2)].map { |i| i.id }.join(',')
    end
    
    describe 'errors' do
      it 'validates Survey titles' do
        title = 'short'
        refute_difference('Survey.count') do
          post :create, survey: {title: title, status: 0}
        end

        refute_nil flash[:alert]
        assert_template :new
      end
    end
    
    it 'works without redirect' do
      title = 'is a valid long title'
      
      assert_difference('Survey.count', 1) do 
        post :create, survey: {title: title, introduction: 'is an introduction long and good', status: 0}
      end
      
      s = Survey.last
      assert_equal title, s.title

      assert_redirected_to surveys_url
    end

    it 'works when questions are added' do
      s=surveys(:survey_1)
      set_title = 'is a valid long'

      # 3 questions go away, 2 are added
      assert_difference('s.survey_questions.count', -1) do 
        post :update, id: s.id, survey: {title: set_title,
                                         introduction: 'is an introduction long and good adding 2 qns',
                                         status: 0}, survey_details: ({'details' => new_survey_question_recs}).to_json
      end

      assert_redirected_to surveys_url
      assert_equal set_title, s.reload.title

      # Questions are ordered correctly.
      assert_equal 2, s.question_assignments.count

      # in the method below, we have ordered sq_2 higher than sq_1
      assert_equal survey_questions(:sq_2).id, s.question_assignments.order(ordering: :asc).first.survey_question_id
    end

    it 'updates status with json' do
      refute_equal Survey::SurveyStatus::CLOSED, surveys(:survey_1).status
      xhr :post, :update, id: surveys(:survey_1).id, survey: {}, status: Survey::SurveyStatus::CLOSED
      s = Survey.find surveys(:survey_1).id
      assert_equal Survey::SurveyStatus::CLOSED, s.status
    end
  end

  private
  def new_survey_question_recs
    [{'id' => survey_questions(:sq_1).id, 'component_rank' => '1'},
     {'id' => survey_questions(:sq_2).id, 'component_rank' => '0'},
     {'id' => -1, 'component_rank' => '5'}]
  end
end
