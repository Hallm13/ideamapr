require 'test_helper'

class RelationalLogicTest < ActiveSupport::TestCase
  include RelationalLogic
  test '#update_has_many!' do
    assert_difference('IdeaAssignment.count', 1) do
      update_has_many! survey_questions(:sq_1), 'Idea', 'IdeaAssignment', [ideas(:idea_1).id, ideas(:idea_2).id],
                       foreign_key: 'groupable_id', polymorphic: true
    end
  end
end

  
