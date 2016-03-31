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
end
