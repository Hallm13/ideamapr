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
  end
end
