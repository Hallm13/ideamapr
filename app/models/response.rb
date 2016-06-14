class Response < ActiveRecord::Base
  belongs_to :survey
  belongs_to :respondent

  has_many :individual_answers
  
  serialize :payload, Array
end
