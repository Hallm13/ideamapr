module RelationalLogic
  def handle_question_request(params)
    # The request can either contain a list of ideas that takes precedence and dynamically creates a question
    # With those ideas, or an ID of an existing question

    qn = nil
    if params[:idea_list]
      # Forces the selection of actual records given any possible unclean list of IDs from the scary Internet.
      cleaned_idea_ids = Idea.where('id in (?)', params[:idea_list]&.split(/,/)).pluck(:id)
      if !cleaned_idea_ids.blank?
        ActiveRecord::Base.transaction do
          qtype_class = "SurveyQuestion::QuestionType::#{params[:question_type].upcase}".constantize
          qn = SurveyQuestion.create question_type: qtype_class
          
          raw_execute(:multi_idea_add, qn, cleaned_idea_ids)
        end
      end
    else
      qn = SurveyQuestion.find_by_id(params[:with_survey_question])
    end
    
    @survey.survey_questions << qn unless qn.nil?
  end
end
