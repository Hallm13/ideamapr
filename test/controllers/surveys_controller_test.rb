require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#index' do
    it 'works' do
      get :index
      assert_select '.cell-1' do |elts|
        assert_equal 4*Survey.count, elts.size
      end
    end
  end
  
  describe '#show' do
    before do
      @survey = surveys(:survey_1)
      @survey.regenerate_public_link
      @survey.save
    end

    it 'works for admin' do
      get :show, id: @survey.id
      assert_template :show
    end
    
    it 'works for public with token' do
      sign_out admins(:admin_1)
      get :public_show, public_link: @survey.public_link, step: 1
      assert_template :public_show
    end
    it 'does not work for public without token' do
      sign_out admins(:admin_1)
      get :public_show, public_link: 'notatoken'
      assert_redirected_to '/404.html'
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
      get :edit, id: '0'
      assert_template :edit
      assert assigns(:survey_status_select)
      assert_match 'Create', response.body
      assert_select('.builder-box') do |elts|
        assert_equal 5, elts.size
      end
    end      
    
    it 'works for existing survey' do
      get :edit, id: surveys(:survey_1).id
      assert_match /Edit/, response.body
      assert_match /survey 1 intro/, response.body
      assert_match /survey 1 title/, response.body
      assert assigns(:survey_status_select)
    end

    it 'works with combining survey questions' do
      get :edit, id: surveys(:survey_1).id, survey: {components: new_survey_question_id_list}
      assert_template :edit
      assert_select('.fa-trash-o', 3)
    end
    
    it 'works with adding survey questions' do
      get :edit, id: surveys(:published_survey).id, survey: {components: new_survey_question_id_list}
      assert_template :edit

      # sq_pre_4 is already assigned
      assert_select('.fa-trash-o', 4)
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
          post :update, id: '0', survey: {title: title, status: 0}
        end

        refute_nil flash[:alert]
        assert_template :edit
      end
    end
    
    it 'works without redirect' do
      title = 'is a valid long title'
      
      assert_difference('Survey.count', 1) do 
        post :update, id: '0', survey: {title: title, introduction: 'is an introduction long and good',
                                        status: 0}
      end
      
      s = Survey.last
      assert_equal title, s.title

      assert_redirected_to survey_url(s)
    end

    it 'works when questions are added' do
      s=surveys(:survey_1)
      assert_difference('s.survey_questions.count', 1) do 
        post :update, id: s.id, survey: {title: 'is a valid long',
                                                          introduction: 'is an introduction long and good',
                                                          status: 0, components: new_survey_question_id_list}
      end

      assert_redirected_to survey_url(surveys(:survey_1))

      get :show, id: surveys(:survey_1).id
      assert_match /2 questions/i, response.body
    end
    
    it 'works to select questions' do
      assert_difference('Survey.count', 1) do 
        post :update, id: '0', survey: {title: 'is a valid long title', introduction: 'is an introduction long and good',
                                        status: 0}, redirect: 'goto-contained'
      end
      s = Survey.last
      assert_redirected_to survey_questions_url(for_survey: s.id)
    end
  end

  private
  def new_survey_question_id_list
    [survey_questions(:sq_1).id, survey_questions(:sq_2).id, -1]
  end
end
