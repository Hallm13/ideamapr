class Survey < ActiveRecord::Base
  class SurveyStatuses
    DRAFT=0
    PUBLISHED=1
    CLOSED=2
  end
  
  has_many :ideas, through: :survey_assignments
  has_many :survey_assignments

  def has_state?(sym)
    Survey::SurveyStatuses.const_defined?(sym.to_s.upcase) && status == "Survey::SurveyStatuses::#{sym.upcase}".constantize
  end
end
