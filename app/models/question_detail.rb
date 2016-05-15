class QuestionDetail < ActiveRecord::Base
  # Model to handle non idea questions that have multiple text fields
  serialize :details_list, Array
  belongs_to :survey_question
end

