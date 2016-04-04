require 'test_helper'

class SqlOptimizersTest < ActiveSupport::TestCase
  include SqlOptimizers
  test 'it works' do
    assert_difference('IdeaAssignment.count', 2) do
      raw_execute(:multi_idea_add, surveys(:survey_1), [ideas(:idea_1).id, ideas(:idea_2).id])
    end
  end
end
