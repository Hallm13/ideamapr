class QuestionAssignment < ActiveRecord::Base
  belongs_to :survey_question
  belongs_to :survey
end
