class Survey < ActiveRecord::Base
  class SurveyStatus
    DRAFT=0
    PUBLISHED=1
    CLOSED=2
  end
  
  validates :title, length: {minimum: 12}

  has_many :ideas, through: :survey_assignments
  has_many :survey_assignments
  belongs_to :owner, class_name: 'User'
  
  has_secure_token

  def has_state?(sym)
    Survey::SurveyStatus.const_defined?(sym.to_s.upcase) && status == "Survey::SurveyStatus::#{sym.upcase}".constantize
  end
end
