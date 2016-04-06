require 'test_helper'

class SurveyQuestionTest < ActiveSupport::TestCase
  test 'question type accessor' do
    assert_equal 'Pro/Con', SurveyQuestion::QuestionType.name(0)
    assert_nil SurveyQuestion::QuestionType.name(100)
  end
end
