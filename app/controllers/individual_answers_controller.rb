class IndividualAnswersController < ApplicationController
  before_action :response_record!
  
  def update
    # For closing out the survey
    if @survey.present?
      @response.closed = true
      @response.save
      render json: ({status: 'success'}), status: 200
    else
      render json: [], status: 422
    end
  end
  
  def create
    # requires params[:sqn_id] (Integer), [:response_data] (JSON string) and [:survey_token] (String)
    # There may be no response already recorded when the first individual save comes along
    
    response_array = nil
    success = false
    message = ''
    
    message = 'invalid parameters'
    begin
      response_hash = JSON.parse params[:response_data]
    rescue JSON::ParserError, ArgumentError => e
      # Protect against JSON parse attacks
      message = 'JSON parse failed'
    end

    if response_hash.is_a?(Hash) and !response_hash['data'].nil?
      @sqn = SurveyQuestion.find_by_id(params[:survey_question_id])

      # there has to be a valid survey question that has exactly as many ideas/fields as the number of responses provided
      if @sqn&.response_length == response_hash['data'].length
        response_fragment =
          IndividualAnswer.find_or_create_by survey_question_id: @sqn.id, survey_public_link: params[:survey_token],
                                             respondent_id: @respondent.id, response: @response
        response_fragment.response_data = response_hash['data']
        response_fragment.save
        
        success = true
        message = 'saved'
      end
    end
    render json: ({success: success, message: message})
  end

  private
  def response_record!
    @respondent = Respondent.find_by_cookie_key cookies['_ideamapr_response_key']
    @response = nil
    @survey = Survey.valid_public_survey?(params[:action] == 'update' ? params[:id] : params[:survey_token])
    
    if @survey
      unless @respondent
        # Don't create a respondent if the survey doesn't exist.
        # Store answers as anonymous without cookies
        c = cookies['_ideamapr_response_key'] || -1
        @respondent = Respondent.find_or_create_by cookie_key: c
      end
      @response = @survey.present? ? (Response.find_or_create_by respondent_id: @respondent.id, survey: @survey) : nil
    end
    
    unless @survey.present?
      render json: ({})
    end
    @survey.present?      
  end
end
