require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  test '#surveys' do
    assert_equal 1, ideas(:idea_1).surveys.count
  end
  test '#survey_questions' do
    assert_equal 3, ideas(:idea_3).survey_questions.count
  end
end
