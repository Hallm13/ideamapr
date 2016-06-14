class IndividualAnswersController < ApplicationController
  def create
    # requires params[:sqn_id] (Integer), [:response_data] (JSON string) and [:survey_token] (String)

    response_array = nil
    success = false
    message = ''

    respondent = Respondent.find_by_cookie_key cookies['_ideamapr_response_key']
    if respondent
      r_id = respondent.id
    else
      # Store answers as anonymous without cookies
      r_id = -1
    end
    
    begin
      response_hash = JSON.parse params[:response_data]
    rescue JSON::ParserError, ArgumentError => e
      # Protect against JSON parse attacks
      message = 'JSON parse failed'
    end

    if response_hash.is_a?(Hash) and !response_hash['data'].nil?
      @sqn = SurveyQuestion.find_by_id(params[:sqn_id])

      # there has to be a valid survey question that has exactly as many ideas/fields as the number of responses provided
      if @sqn&.response_length == response_hash['data'].length
        r = IndividualAnswer.find_or_create_by survey_question_id: @sqn.id, survey_public_link: params[:survey_token],
                                               respondent_id: r_id
        r.response_data = response_hash['data']
        r.save
        success = true
        message = 'saved'
      else
        message = 'invalid request'
      end
    else
      message = 'invalid parameters'
    end

    Rails.logger.debug message
    render json: ({success: success, message: message})
  end
end
