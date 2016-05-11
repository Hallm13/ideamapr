require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in admins(:admin_1)
  end
  
  describe '#index' do
     it 'works plainly' do
       get :index
       assert_template :index
       assert_equal 'ideas', assigns(:selected_section)
     end
     it "activates selection when asked" do
       sq = survey_questions :sq_1
       get :index, {add_to_survey_question: sq.id}

       assert_equal (Idea.count - sq.ideas.count), assigns(:ideas).count
       refute_nil assigns(:question)
       assert_select('.fa.fa-check.active-icon')
     end
     it 'returns all ideas for questions that have none' do
       sq = survey_questions :sq_no_ideas
       get :index, {add_to_survey_question: sq.id}
       assert_equal Idea.count, assigns(:ideas).count
     end

     describe 'getting ideas for a survey' do
       # temporary - make this for a survey question in public view later
       it 'handles errors' do
         get :index, {for_survey: -1}
         assert_redirected_to '/404.html'
       end
       
       it 'gets the ideas for a survey' do
         s=surveys(:published_survey)
         get :index, {for_survey: s.id}
         assert s.survey_questions.order(created_at: :desc).first.ideas.order(created_at: :desc).first.id,
                assigns(:ideas).first.id
       end

       it 'is not authenticated for XHR requests for published surveys' do
         xhr :get, :index, {for_survey: surveys(:published_survey).id}
       end
     end
  end
  
  describe '#show' do
    describe 'errors' do
      it 'needs a valid id' do
        get :show, {id: 'notid'}
        assert_redirected_to '/404.html'
      end
      it 'needs a login' do
        sign_out :admin
        get :show, {id: ideas(:idea_1).id}
        assert_redirected_to new_admin_session_path
      end
    end

    describe 'success' do
      it 'gets an idea' do
        get :show, {id: ideas(:idea_1).id}
        assert_template :show
      end
    end
  end

  describe '#create' do
    it 'is successful' do
      put :update, id: 0, idea: {title: 'is a long title', description: "is a long title and description"}
      assert_redirected_to idea_path(Idea.last)
    end

    it 'shows errors' do
      put :update, id: 0, idea: {title: 'is a', description: "is"}
      assert_template :edit
      assert_match /Idea /, response.body
    end
  end
end
