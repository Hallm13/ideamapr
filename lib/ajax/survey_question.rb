module Ajax
  class SurveyQuestion
    def self.run_ajax_action(action, *args)
      args.flatten!
      params = args[0]

      struct = {}
      case action
      when 'get_prompt_map'
        struct[:data] = ::SurveyQuestion::QuestionType.prompts
        struct[:status] = true
      else
        struct[:status] = false
      end
      
      struct
    end
  end
end
