require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
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
      get :show, id: @survey.id, token: @survey.token
      assert_template :show
    end
    it 'does not work for public without token' do
      get :show, id: @survey.id, token: 'notatoken'
      assert_redirected_to '/404.html'
    end
  end

  describe '#edit' do
    describe '404 errors' do
      it 'is triggered by bad step' do
        get :edit, step_command: 'notastep'
      end
      it 'is triggered by bad survey' do
        get :edit, step_command: :add_ranking_screen, with_survey: :abc
      end
      after do
        assert_redirected_to '/404.html'
      end
    end

    it 'works for init' do
      get :edit, step_command: :init
      assert_template :new
      assert_select 'input[type=hidden]' do |elts|
        k = elts.select { |elt| elt['name'] == 'step_command'}
        assert_equal 1, k.size
        assert_equal 'init', k[0]['value']
      end
    end      
    
    it 'works for step add-ranking-screen' do
      get :edit, step_command: :add_ranking_screen, with_survey: surveys(:survey_1).id
      assert_match /idea 1/, response.body
      assert assigns(:payload)
      
      assert_select('.idea-box') do |elts|
        assert_equal Idea.count, elts.size
      end
    end
  end
  
  describe '#update' do
    it 'handles errors' do
      title = 'short'
      refute_difference('Survey.count') do
        post :update, step_command: 'init', title: title
      end
      assert_template :new
    end
    
    it 'works to init' do
      title = 'is a valid title'
      
      assert_difference('Survey.count', 1) do
        post :update, step_command: 'init', title: title
      end
      s = Survey.last
      assert_equal title, s.title

      assert_redirected_to survey_url(s)
    end

    it 'works to add ranking screen' do
      s = surveys(:survey_1)
      post :update, step_command: 'add_ranking_screen', with_survey: s.id
      assert_redirected_to survey_url(s)
    end
  end
end
