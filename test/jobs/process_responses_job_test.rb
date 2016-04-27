require 'test_helper'

class ProcessResponsesJobTest < ActiveJob::TestCase
  def setup
    @answer = responses :response_1
    @survey = surveys :published_survey
    
    @answer.payload =
      [{'sqn_id' => "#{@survey.survey_questions.first.id}",
        'answers' => [
         {'idea_id' => "-1"},
         {'idea_id' => "#{@survey.survey_questions.first.ideas.first.id}", pro: "1"}
        ]}]
    
    @answer.save
  end

  test 'job works' do
    ProcessResponsesJob.perform_now @answer
    new_payload = Response.last.payload

    assert_equal [{:sqn_id=>@survey.survey_questions.first.id,
                   :answers=>[{"idea_id"=>@survey.survey_questions.first.ideas.first.id, :pro=>"1"}]}], new_payload
  end
  
end
