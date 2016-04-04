class Survey < ActiveRecord::Base
  class SurveyStatus
    DRAFT=0
    PUBLISHED=1
    CLOSED=2
  end
  
  validates :title, length: {minimum: 12}

  has_many :survey_questions, through: :question_assignments
  has_many :question_assignments
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable

  belongs_to :owner, class_name: 'User'
  
  has_secure_token

  def has_state?(sym)
    Survey::SurveyStatus.const_defined?(sym.to_s.upcase) && status == "Survey::SurveyStatus::#{sym.upcase}".constantize
  end
end
