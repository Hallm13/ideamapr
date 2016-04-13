require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  describe '#index' do
     it 'works plainly' do
       get :index
       assert_template :index
       assert_equal 'ideas', assigns(:selected_section)
     end
     it "activates selection when asked" do
       get :index, {for_survey_question: survey_questions(:sq_1).id}
       refute_nil assigns(:question)
       assert_select('.fa.fa-check.active-icon')
     end
  end  
  
  test '#show' do
    get :show, {id: ideas(:idea_1).id}
    assert_template :show
  end

  test '#new' do
    get :new
  end
  
  test '#show' do
    get :show, {id: 'notid'}
    assert_redirected_to root_path
  end

  describe '#create' do
    it 'is successful' do
      post :create, idea: {title: 'is a long title', description: "is a long title and description"}
      assert_redirected_to idea_path(Idea.last)
    end

    it 'shows errors' do
      post :create, idea: {title: 'is a', description: "is"}
      assert_template :new
      assert_match /Idea /, response.body
    end
  end
end
