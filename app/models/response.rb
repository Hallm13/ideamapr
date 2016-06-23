class Response < ActiveRecord::Base
  belongs_to :survey
  belongs_to :respondent

  has_many :individual_answers
  
  serialize :payload, Array
  after_initialize :set_open

  private
  def set_open
    unless closed
      self.closed = false
    end
  end
end
