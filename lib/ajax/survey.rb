module Ajax
  class Survey
    def self.run_ajax_action(action, *args)
      args.flatten!
      struct = {}

      # The call might be to delete an unsaved question so there's no way to return a failure right now.
      status = true
      
      case action
      when 'delete_survey_question'
        survey_id = args[0]
        sqn_id = args[1]
        if sq_a = QuestionAssignment.where(survey_id: survey_id.to_i, survey_question_id: sqn_id.to_i).first
          struct[:data] = sq_a.id
          sq_a.delete
        end
      end
      
      struct[:status] = status
      struct
    end
  end
end
