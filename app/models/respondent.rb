class Respondent < ActiveRecord::Base
  has_many :responses, dependent: :destroy
  has_many :individual_answers, dependent: :destroy
  has_many :surveys, through: :responses

  has_secure_token :cookie_key
end
