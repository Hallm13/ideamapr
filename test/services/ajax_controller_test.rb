module Ajax
  class LibraryTest < ActiveSupport::TestCase
    def setup
      @sqn = survey_questions(:sq_1)
      @idea = @sqn.ideas.first
    end
    
    test 'get survey question map' do
      data = Ajax::Library.route_action("survey_question/get_prompt_map/")
      
      # Should be equal to number of questions types
      assert_equal 7, data[:data].keys.size
    end

    test 'getting help text' do
      data = Ajax::Library.route_action("cms/get/help_text")
      assert_equal ::CmsContent.count, data[:data].count
    end

    test 'getting cms content' do
      data = Ajax::Library.route_action("cms/get/#{cms_contents(:ht_one).id}")
      assert_equal cms_contents(:ht_one).cms_text, data[:data].cms_text
    end

    test 'delete idea from question' do
      assert_difference('IdeaAssignment.count', -1) do
        data = Ajax::Library.route_action("survey_question/delete_idea/#{@sqn.id}/#{@idea.id}")
      end
    end

    test 'destroy survey_question' do
      sqn = survey_questions(:sq_pre_5_procon)
      assert_difference('IdeaAssignment.count', sqn.idea_assignments.count * -1) do
        data = Ajax::Library.route_action("survey_question/destroy/#{sqn.id}")
      end
    end
    
    test 'destroy survey' do
      surv = surveys(:answered_survey)
      assert_difference('QuestionAssignment.count', surv.question_assignments.count * -1) do
        data = Ajax::Library.route_action("survey/destroy/#{surv.id}")
      end
    end
    
    test 'destroy idea' do
      idea = ideas(:idea_3)
      assert_difference('IdeaAssignment.count', idea.idea_assignments.count * -1) do
        data = Ajax::Library.route_action("idea/destroy/#{idea.id}")
      end
    end
  end
end

