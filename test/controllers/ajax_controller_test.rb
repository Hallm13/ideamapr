require 'test_helper'

class AjaxControllerTest < ActionController::TestCase
  test 'routing' do
    assert_routing ({path: '/ajax_api', method: :post}), {controller: 'ajax', action: 'multiplex'}
    assert_routing ({path: '/ajax_api', method: :get}), {controller: 'ajax', action: 'multiplex'}
  end
  
  test '#multiplex' do
    xhr :post, :multiplex, {payload: "survey_question/get_prompt_map/"}
    assert_equal 'success', JSON.parse(response.body)['status']
  end

  describe '#destroy' do
    it 'handles errors' do
      refute_difference('IdeaAssignment.count') do
        xhr :post, :multiplex, {payload: "survey_question/noaction/1/2"}
      end
      assert_equal 'error', JSON.parse(response.body)['status']
      
      refute_difference('Idea.count') do
        xhr :post, :multiplex, {payload: "idea/destroy/-10"}
      end
      assert_equal 'error', JSON.parse(response.body)['status']
      
      refute_difference('SurveyQuestion.count') do
        xhr :post, :multiplex, {payload: "survey_question/destroy/-10"}
      end

      assert_equal 'error', JSON.parse(response.body)['status']
    end
  end

  describe '#delete_attachment' do
    it 'works' do
      i = ideas(:idea_with_img)

      assert_difference('DownloadFile.count', -1) do
        xhr :post, :multiplex, {payload: "idea/delete_attachment/#{i.download_files.first.id}"}
      end
    end
    it 'handles errors' do
      refute_difference('DownloadFile.count') do
        xhr :post, :multiplex, {payload: "idea/delete_attachment/-10"}
      end

      assert_equal 'error', JSON.parse(response.body)['status']
    end      
  end

  test 'error' do
    xhr :post, :multiplex, {payload: "bat/update/man/changed_to"}
    assert_equal 'error', JSON.parse(response.body)['status']
  end
end
