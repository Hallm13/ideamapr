class SurveyQuestion < ActiveRecord::Base
  class QuestionType
    PROCON=0
  end
  
  has_many :question_assignments
  has_many :surveys, through: :question_assignments
  
  has_many :ideas, through: :idea_assignments
  has_many :idea_assignments, as: :groupable
end
