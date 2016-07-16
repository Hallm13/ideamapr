require 'test_helper'
class RespondentsControllerTest < ActionController::TestCase
  test 'works with token' do
    a = Admin.first
    a.regenerate_auth_token
    t = Admin.first.auth_token
    xhr :get, :reset, {auth_token: t}

    assert JSON.parse(response.body)['status']
  end
end
