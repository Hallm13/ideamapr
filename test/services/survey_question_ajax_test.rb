require 'test_helper'
class SurveyQuestionAjaxTest < ActiveSupport::TestCase
  def setup
    @sq = survey_questions(:sq_1)
    @ia_3 = ideas(:idea_3)
  end
  
  test 'can delete idea from SQ' do
    resp = Ajax::SurveyQuestion.run_ajax_action('delete_idea', @sq.id, @ia_3.id)
    assert resp[:status]
  end
end
