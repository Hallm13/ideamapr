require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  test '#show' do
    get :show, {id: ideas(:idea_1).id}
    assert_template :show
  end
  test '#show' do
    get :show, {id: 'notid'}
    assert_redirected_to root_path
  end
end
