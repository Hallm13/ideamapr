require 'test_helper'

class SurveyQuestionTest < ActiveSupport::TestCase
  test 'question type accessor' do
    assert_equal 'Pro/Con', SurveyQuestion::QuestionType.name(0)
    assert_nil SurveyQuestion::QuestionType.name(100)
  end

  test 'question type enum' do
    assert_equal 7, SurveyQuestion.new.question_type_enum.keys.size
  end

  test '#set_default_prompt' do
    s = SurveyQuestion.new(question_type: 3); s.set_default_prompt
    assert_match /defaults\.budgeting/, s.question_prompt
  end
end
