require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  describe 'unauthenticated' do
    it 'does not work' do
      get :show
      assert_redirected_to new_admin_session_path
    end
  end
end

    
