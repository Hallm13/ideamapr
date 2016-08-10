module Ajax
  class SurveyQuestion
    def self.run_ajax_action(action, *args)
      args.flatten!
      params = args[0]

      struct = {}
      case action
      when 'destroy'
        id = args[0]
        if obj = ::SurveyQuestion.find_by_id(id)
          obj.destroy
          struct[:status] = true
        else
          struct[:status] = false
        end
      when 'get_prompt_map'
        struct[:data] = ::SurveyQuestion::QuestionType.prompts.inject({}) do |trans_hash, pair|
          trans_hash[pair[0]] = I18n.t pair[1]
          trans_hash
        end
        struct[:status] = true
      when 'delete_idea'
        sqn_id = args[0]
        idea_id = args[1]
        if id_a = IdeaAssignment.where(groupable_type: 'SurveyQuestion',
                                       groupable_id: sqn_id.to_i, idea_id: idea_id.to_i).first
          struct[:data] = id_a.id
          id_a.delete
          struct[:status] = true
        end
      else
        struct[:status] = false
      end
      
      struct
    end
  end
end
