require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  def setup
    @s = surveys(:published_survey)
    @s.status = Survey::SurveyStatus::PUBLISHED
    @s.save
  end
  
  test '#has_state?' do
    assert @s.has_state?(:published)
  end

  test '##status_enum' do
    assert_equal({'Draft' => 0, 'Published' => 1, 'Closed' => 2}, Survey.new.status_enum)
  end

  test 'SurveyStatus##id' do
    assert_equal 1, Survey::SurveyStatus.id('Published')
  end

  test '#publish!' do
    @s = surveys(:survey_1)
    refute @s.public_link.present?
    @s.publish!

    assert @s.reload.has_state?(:published)
    assert @s.public_link.present?
  end

  test 'reporting' do
    s = surveys :answered_survey
    i = individual_answers(:ia_answered_ranking_1)
    i.response_data = [{'idea_id' => ideas(:idea_1).id},
                       {'idea_id' => ideas(:idea_2).id},
                       {'idea_id' => ideas(:idea_3).id}]
    i.save
    
    i = individual_answers(:ia_answered_ranking_2)
    i.response_data = [{'idea_id' => ideas(:idea_3).id},
                       {'idea_id' => ideas(:idea_2).id},
                       {'idea_id' => ideas(:idea_1).id}]
    i.save

    i = individual_answers(:ia_answered_procon_2)
    i.response_data = [{'idea_id' => ideas(:idea_2).id, 'type-0-data' => {feedback: {pro: [5,6,7], con: [1]}}},
                       {'idea_id' => ideas(:idea_3).id, 'type-0-data' => {feedback: {pro: [1], con: [2,2,2,2,2]}}}
                      ]
    i.save
    
    puts s.report_hash
  end
end
