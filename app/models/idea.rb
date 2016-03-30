class Idea < ActiveRecord::Base
  has_many :surveys, through: :survey_assignments
  has_many :survey_assignments

  validates :title, length: {minimum: 12}
end
