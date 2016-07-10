class IndividualAnswer < ActiveRecord::Base
  belongs_to :response
  belongs_to :survey_question
  belongs_to :respondent
  
  belongs_to :survey, foreign_key: :survey_public_link, primary_key: :public_link
end
