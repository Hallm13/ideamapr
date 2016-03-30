class SurveyAssignment < ActiveRecord::Base
  belongs_to: :idea
  belongs_to: :survey
end
