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

    i = individual_answers(:ia_answered_toppri)
    i.response_data = [{'idea_id' => ideas(:idea_2).id, 'component_rank' => 0, 'checked' => false},
                       {'idea_id' => ideas(:idea_3).id, 'component_rank' => 1, 'checked' => true}
                      ]
    i.save

    save_budget_answers
    i = individual_answers(:ia_answered_radio)
    i.response_data = [{'text' => 'hot',  'idea_id' => ideas(:idea_2).id, 'checked' => true}, 
                       {'text' => 'cold', 'idea_id' => ideas(:idea_3).id, 'checked' => false}
                      ]
    i.save

    i = individual_answers(:ia_answered_new_idea_1)
    i.response_data = [{'answered' => true, 'title' => 'hot',  'description' => '.id'},
                       {'answered' => true, 'title' => 'hot',  'description' => '.id'}
                      ]
    i.save

    i = individual_answers(:ia_answered_text_fields)
    i.response_data = [{'answered' => true, 'text' => 'hot',  'text_entry' => '.id'},
                       {'answered' => true, 'text' => 'cold',  'text_entry' => '.id'}
                      ]
    i.save

    budget_rep = s.report_hash[:answer_stats].
                 select { |r| r[:question_id] == survey_questions(:sq_budget_type).id }.first

    assert_equal 1500.0/4, budget_rep[:sorted_idea_avg_budget][0][2]
    assert_equal 1200.0/4, budget_rep[:sorted_idea_avg_budget][1][2]
    assert_equal 500, budget_rep[:sorted_idea_avg_budget][0][3]
    refute_nil s.full_report_hash
  end

  private
  def save_budget_answers
    # 1,2,3 = 500, 400, 700 budgets
    i = individual_answers(:ia_answered_budget_1)
    i.response_data = [{'idea_id' => ideas(:idea_1).id, 'component_rank' => 0, cart_count: 1, cart_amount: 500},
                       {'idea_id' => ideas(:idea_2).id, 'component_rank' => 1, cart_count: 1, cart_amount: 400},
                       {'idea_id' => ideas(:idea_3).id, 'component_rank' => 2, cart_count: 0}
                      ]
    i.save
    
    i = individual_answers(:ia_answered_budget_2)
    i.response_data = [{'idea_id' => ideas(:idea_1).id, 'component_rank' => 0, cart_count: 1, cart_amount: 500},
                       {'idea_id' => ideas(:idea_2).id, 'component_rank' => 1, cart_count: 0, cart_amount: 400},
                       {'idea_id' => ideas(:idea_3).id, 'component_rank' => 2, cart_count: 1}
                      ]
    
    i.save
    i = individual_answers(:ia_answered_budget_3)
    i.response_data = [{'idea_id' => ideas(:idea_1).id, 'component_rank' => 0, cart_count: 1, cart_amount: 500},
                       {'idea_id' => ideas(:idea_2).id, 'component_rank' => 1, cart_count: 1, cart_amount: 400},
                       {'idea_id' => ideas(:idea_3).id, 'component_rank' => 2, cart_count: 1}
                      ]
    
    i.save
    i = individual_answers(:ia_answered_budget_4)
    i.response_data = [{'idea_id' => ideas(:idea_1).id, 'component_rank' => 0, cart_count: 0},
                       {'idea_id' => ideas(:idea_2).id, 'component_rank' => 1, cart_count: 1, cart_amount: 400},
                       {'idea_id' => ideas(:idea_3).id, 'component_rank' => 2, cart_count: 0}
                      ]
    
    i.save
  end
end
