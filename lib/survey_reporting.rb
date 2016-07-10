require 'active_support/concern'
module SurveyReporting
  extend ActiveSupport::Concern
  included do
    # Instance methods
    def report_hash
      { individual_answer_count: self.individual_answers.count,
        respondent_count: self.respondents.count,
        finish_count: self.responses.where(closed: true).count
      }
    end
  end

  class_methods do
    # Class methods
  end
end
