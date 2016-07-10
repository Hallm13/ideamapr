class Respondent < ActiveRecord::Base
  has_many :responses
  has_many :surveys, through: :responses

  has_secure_token :cookie_key
end
