require 'test_helper'
class IndividualAnswersControllerTest < ActionController::TestCase
  test 'JSON parsing is protected' do
    post :create, response_data: "["
  end

  test 'invalid data' do
    refute_difference('IndividualAnswer.count') do
      post :create, response_data: ({list: [1,2]}).to_json
    end
  end

  test 'valid data' do
    assert_difference('IndividualAnswer.count', 1) do
      post :create, sqn_id: survey_questions(:sq_1).id, response_data: ({data: [1]}).to_json
    end
  end

  test 'cookied requests overwrite' do
    cookies['_ideamapr_response_key'] = 'testercookie'
    assert_difference('IndividualAnswer.count', 1) do
      post :create, sqn_id: survey_questions(:sq_1).id, response_data: ({data: [1]}).to_json
      post :create, sqn_id: survey_questions(:sq_1).id, response_data: ({data: [2]}).to_json
    end

    assert_equal 2, IndividualAnswer.last.response_data[0]
  end
end
