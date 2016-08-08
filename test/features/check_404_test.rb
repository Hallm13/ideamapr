require 'test_helper'

class RedirectFor404Test < Capybara::Rails::TestCase
  # General tests for what signed in and out users

  def setup
    Capybara.default_driver = :webkit
    login_as admins(:admin_1), scope: :admin
  end
  
  test '404 redirects to sign in page' do
    visit '/not_a_route_at_all'
    assert_match /404.html/, page.current_path
  end

  test 'click on homepage on idea will not generate a 404' do
    visit '/'
    sleep 1
    page.all('.idea-card-row').first.click
    refute_match /404/, page.current_path
  end
end
