require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  def setup
    sign_in admins(:admin_1)
    set_net_stubs
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
       b = JSON.parse(response.body)
       
       assert_equal Idea.count, b.size
       assert_equal false, b.first['is_assigned'] # false, not just nil

       # The idea with an attachment has its URL available
       assert_equal 1, b.select { |i| i['id'] == ideas(:idea_with_img).id && i['image_url'] != ''}.size
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
    it 'is successful without attachments' do
      post :create, idea: {title: 'is a long title', description: "is a long title and description"}
      assert_redirected_to ideas_path(Idea.last)
    end
    it 'is successful with attachments' do
      assert_difference('DownloadFile.count', 1) do
        post :create, idea: {title: 'is a long title', description: "is a long title and description",
                             attachment: fixture_file_upload('files/image.png', 'image/png')}
      end
    end
    
    it 'shows errors' do
      post :create, idea: {title: 'iz a', description: "is"}
      assert_template :new
      assert_match /iz a/, response.body
    end
  end

  test '#edit' do
    get :edit, id: ideas(:idea_with_img).id
    assert_template :edit
  end
end
