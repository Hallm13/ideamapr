require 'test_helper'

class PublicInfoControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test 'ordering of ideas' do
    get :double_bundle, for_survey: surveys(:published_survey).public_link
    b = JSON.parse response.body

    # The radio choice question is the 2nd one assigned to published_survey
    assert_equal 'detail', b['list_of_lists'][1]['type']
  end
end
