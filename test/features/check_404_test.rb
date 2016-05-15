require 'test_helper'

class RedirectFor404Test < Capybara::Rails::TestCase
  # General tests for what signed in and out users

  test '404 redirects to sign in page' do
    visit '/not_a_route_at_all'
    assert_match /404.html/, page.current_path
  end
end
