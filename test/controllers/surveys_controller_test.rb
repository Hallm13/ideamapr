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
      @survey.regenerate_token
      @survey.save
    end
    
    it 'works for public with token' do
      sign_out admins(:admin_1)
      get :show, id: @survey.id, token: @survey.token
      assert_template :show
    end
    it 'does not work for public without token' do
      sign_out admins(:admin_1)
      get :show, id: @survey.id, token: 'notatoken'
      assert_redirected_to '/404.html'
    end
  end

  describe 'authorization' do
    it 'is required for non public view' do
      sign_out admins(:admin_1)
      get :edit, step_command: 'init'
      assert_redirected_to new_admin_session_path
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
        assert_equal 3, elts.size
      end
    end      
    
    it 'works for existing survey' do
      get :edit, id: surveys(:survey_1).id
      assert_match /Edit/, response.body
      assert assigns(:survey_status_select)
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
    
    it 'works to init' do
      title = 'is a valid long title'
      
      assert_difference('Survey.count', 1) do 
        post :update, id: '0', survey: {title: title, status: 0}
      end
      
      s = Survey.last
      assert_equal title, s.title

      assert_redirected_to survey_url(s)
    end
  end
end
