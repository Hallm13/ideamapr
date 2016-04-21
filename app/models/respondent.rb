class Respondent < ActiveRecord::Base
  has_many :responses

  has_secure_token :cookie_key
end
