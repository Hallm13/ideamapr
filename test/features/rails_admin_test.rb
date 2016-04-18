require 'test_helper'
class RailsAdminTest < Capybara::Rails::TestCase
  include Warden::Test::Helpers
  Warden.test_mode!
  # Hit coverage goals
  describe 'rails admin loads' do
    it 'needs auth' do
      visit '/rails_admin/user'
      assert_equal '/admins/sign_in', current_path
    end

    it 'loads users' do
      login_as admins(:admin_1), scope: :admin
      visit '/rails_admin/survey'
      assert_equal '/rails_admin/survey', current_path
    end
  end
end
