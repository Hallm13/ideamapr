require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  describe '#show' do
    before do
      @survey = surveys(:survey_1)
      @survey.regenerate_token
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

  describe '#new' do
    describe '404 errors' do
      it 'is triggered by bad step' do
        get :new, step: 200
      end
      it 'is triggered by bad survey' do
        get :new, step: 2, with_survey: :abc
      end
      after do
        assert_redirected_to '/404.html'
      end
    end
    
    it 'works for step 2' do
      get :new, step: 2, with_survey: surveys(:survey_1).id
      assert assigns(:payload)
      assert_match /idea 1/, response.body
    end
  end

  describe '#update' do
    it 'works to save step 1' do
      assert_difference('Survey.count', 1) do
        post :update, save_step: 1, title: 'is a title'
      end
      assert_equal 'is a title', Survey.last.title

      assert_redirected_to surveys_url(step: 2)
    end
  end
end
