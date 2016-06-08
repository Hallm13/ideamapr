require 'test_helper'

class RelationalLogicTest < ActiveSupport::TestCase
  include SqlOptimizers
  include RelationalLogic
  describe '#update_has_many!' do
    it 'works normally' do
      s=survey_questions(:sq_1)
      assert_difference('s.ideas.count', 2) do
        update_has_many! s, 'Idea', 'IdeaAssignment', [ideas(:idea_1).id, ideas(:idea_2).id],
                         foreign_key: 'groupable_id', polymorphic: true
      end

      by_ordering = s.idea_assignments.order(ordering: :asc)
      assert_equal 2, by_ordering.last.ordering #sq_1 already has one idea in the fixtures
    end

    it 'works to delete existing containeds' do
      s=survey_questions(:sq_1)
      assert_difference('s.ideas.count', 1) do
        update_has_many! s, 'Idea', 'IdeaAssignment', [ideas(:idea_1).id, ideas(:idea_2).id],
                         foreign_key: 'groupable_id', polymorphic: true, should_delete: true
      end

      by_ordering = s.idea_assignments.order(ordering: :asc)
      assert_equal 1, by_ordering.last.ordering #sq_1 already has one idea in the fixtures
    end
    
    it 'works when added ids are faulty' do
      s = survey_questions(:sq_1)
      assert_difference('s.ideas.count', 2) do
        update_has_many! s, 'Idea', 'IdeaAssignment', [ideas(:idea_1).id, ideas(:idea_2).id, -1],
                         foreign_key: 'groupable_id', polymorphic: true
      end
    end      
  end

  describe 'handle_question_request' do
    it 'works when called without setting instance variable' do
      refute_difference('SurveyQuestion.count') do
        handle_question_request({})
      end
    end

    it 'works normally' do
      @survey = surveys(:survey_1)
      idea_list = [ideas(:idea_1).id, ideas(:idea_2).id]
      assert_difference('SurveyQuestion.count') do
        handle_question_request({idea_list: idea_list, question_type: 0})
      end
    end
  end
end
