require 'test_helper'

class PublicInfoControllerTest < ActionController::TestCase
  test 'ordering of ideas' do
    get :double_bundle, for_survey: surveys(:published_survey).public_link
    b = JSON.parse response.body

    # The radio choice question is the 2nd one assigned to published_survey
    assert_equal 'detail', b['list_of_lists'][1]['type']

    # 1st idea in 3rd question has a budget amount in the fixtures
    assert_equal 500.0, b['list_of_lists'][3]['data'][0]['cart_amount']
  end
end
