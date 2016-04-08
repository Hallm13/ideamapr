require 'test_helper'

class AjaxControllerTest < ActionController::TestCase
  test '#multiplex' do
    xhr :post, :multiplex, {payload: "survey_question/get_prompt_map/"}
    assert_equal 'success', JSON.parse(response.body)['status']
  end

  test 'error' do
    xhr :post, :multiplex, {payload: "bat/update/man/changed_to"}
    assert_equal 'error', JSON.parse(response.body)['status']
  end
end
