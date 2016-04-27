class Response < ActiveRecord::Base
  belongs_to :survey
  belongs_to :respondent

  serialize :payload, Array
end
