require 'test_helper'
class IdeaAssignmentTest < ActiveSupport::TestCase
  test 'auto ranking works' do
    ia = IdeaAssignment.new groupable_type: 'SurveyQuestion', groupable_id: survey_questions(:sq_pre_4).id

    # sq_pre_4 already has two ideas assigned in the fixtures
    assert_equal 2, ia.ranking
  end
end
