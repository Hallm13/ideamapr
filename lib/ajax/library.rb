module Ajax
  class Library
    def self.route_action(action_str)
      status_struct = {'status' => 'error'}
      
      matches = /^(\w+)\/(\w+)\/(.*)/.match(action_str)
      if matches
        controller = matches[1]
        action = matches[2]
        params = matches[3].split '/'                                  
        
        case controller
        when 'survey'
          status_struct = Ajax::Survey.run_ajax_action(action, params)
        when 'survey_question'
          status_struct = Ajax::SurveyQuestion.run_ajax_action(action, params)
        when 'cms'
          status_struct = Ajax::CmsContent.run_ajax_action(action, params)
        end
      end
      status_struct
    end
  end
end
