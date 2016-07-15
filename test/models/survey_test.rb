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
end
