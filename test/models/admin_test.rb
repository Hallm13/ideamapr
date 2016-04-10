require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  test 'devise validation works' do
    refute Admin.new.valid?
    assert admins(:admin_1).has_password?('password')
    refute admins(:admin_1).has_password?(1)
  end

  test 'valid model save' do
    assert_difference('Admin.count', 1) do
      Admin.new(email: 'email@emails.com', password: 'apssword123').save
    end
  end
end
