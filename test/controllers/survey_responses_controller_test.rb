require 'test_helper'

class SurveyResponsesControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper
  def setup
    @survey = surveys(:published_survey)
    @draft = surveys(:survey_1)
    
    @response_payload = [{sqn_id: -1, answers: []}, {sqn_id: @survey.survey_questions.first.id, answers: []},
                         {sqn_id: survey_questions(:sq_1).id, answers: []}]
  end
  
  test 'filtering of IDs in response' do
    sz = enqueued_jobs.count
    
    assert_difference('Response.count', 1) do
      xhr :post, :update, id: 0, survey_id: @survey.id, responses: @response_payload
    end

    # The survey ID response of -1 is rejected
    assert_equal 1, Response.last.payload.length
    assert_equal sz + 1, enqueued_jobs.count
  end
end
