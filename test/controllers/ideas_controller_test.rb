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
       assert_equal :ideas, assigns(:navbar_active_section)
     end

     it 'for admins, new survey questions gets all ideas' do
       # XHR request for new SQ will send SQ id = 0
       xhr :get, :index, for_survey_question: '0'
       assert_equal Idea.count, JSON.parse(response.body).size
     end

     describe 'getting ideas for a survey' do
       it 'separates ideas on assignment basis' do
         # has idea_3 assigned to it
         xhr :get, :index, {for_survey_question: survey_questions(:sq_1).id}

         resp = JSON.parse response.body
         t = resp.select { |i| /idea 3/.match(i['title'])}.first

         assert t['is_assigned']
         assert_equal 42.42, t['cart_amount']
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

  test '#new' do
    get :new
    assert_template :new
  end
  
  describe '#create' do
    it 'is successful' do
      post :create, idea: {title: 'is a long title', description: "is a long title and description"}
      assert_redirected_to idea_path(Idea.last)
    end

    it 'shows errors' do
      post :create, idea: {title: 'is a', description: "is"}
      assert_template :edit
      assert_match /Idea /, response.body
    end
  end
end
