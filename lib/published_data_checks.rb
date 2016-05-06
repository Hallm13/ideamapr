module PublishedDataChecks
  def set_public_survey_or_admin!
    # Published surveys can have their questions and ideas revealed
    # if the survey's token is presented (via JSON)

    if params[:for_survey].nil?
      return authenticate_admin!
    end
    
    if request.xhr?
      s = Survey.find_by_public_link(params[:for_survey])
      if s && s.status == Survey::SurveyStatus::PUBLISHED
        @survey = s
        return true
      end

      if s.nil?
        s = Survey.find_by_id params[:for_survey]
      end
      if s.nil?
        # if the survey can't be found, it doesn't matter who's logged in
        return false
      end
    else
      s = Survey.find_by_id(params[:for_survey]) || Survey.find_by_public_link(params[:for_survey])
    end
    
    @survey = s
    authenticate_admin!
  end
end
