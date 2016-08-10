class IndividualAnswersController < ApplicationController
  before_action :response_record!
  
  def update
    @response.closed = true
    @response.save
    render json: ({success: true}), status: 200
  end
  
  def create
    # requires params[:sqn_id] (Integer), [:response_data] (JSON string) and [:survey_token] (String)
    # There may be no response already recorded when the first individual save comes along
    
    response_array = nil
    success = false
    # all these are now guaranteed to be set.
    response_fragment =
      IndividualAnswer.find_or_create_by survey_question_id: @sqn.id, survey_public_link: params[:survey_token],
                                         respondent_id: @respondent.id, response: @response
    if response_fragment.response_data != @response_hash['data']
      response_fragment.response_data = @response_hash['data']
      
      saved = true
      begin
        ActiveRecord::Base.transaction do
          if @sqn.question_type == SurveyQuestion::QuestionType::NEW_IDEA
            @response_hash['data'].each do |idea_rec|
              if idea_rec.is_a? Hash
                idea_record = Idea.find_or_initialize_by title: idea_rec['title'],
                                                         description: idea_rec['description'],
                                                         source: 'survey'
                saved &&= idea_record.save if idea_record.new_record?
              end
            end
          end
          saved &&= response_fragment.save
        end
      rescue ActiveRecord::RecordInvalid => e
        saved = false
      end
    end
    
    render json: ({success: saved, message: saved ? 'saved' : 'not saved'})
  end

  private
  def response_record!
    params[:survey_token] ||= params[:id]

    @survey = Survey.valid_public_survey? params[:survey_token]
    c = cookies['_ideamapr_response_key'] || -1
    if @survey
      @respondent = Respondent.find_by_cookie_key c
      @response = nil
      if @respondent.nil?
        # Don't create a respondent if the survey doesn't exist.
        # Store answers as anonymous without cookies
        @respondent = Respondent.find_or_initialize_by cookie_key: c
        @response = Response.new survey: @survey
      else
        @response = Response.find_or_create_by respondent_id: @respondent.id, survey: @survey
      end
    end
    
    status = @survey.present?
    if params[:action] == 'create'
      @sqn = SurveyQuestion.find_by_id params[:survey_question_id]
      if (status &&= @sqn.present?)
        # Check if we have a valid survey question and individual answer data
        begin
          @response_hash = JSON.parse params[:response_data]
          if @response_hash.is_a?(Hash) and !@response_hash['data'].nil?
            # there has to be a valid survey question that has exactly as many ideas/fields
            # as the number of responses provided
            length = @sqn&.response_length            
            status &&= (length == -1 || length == @response_hash['data'].length)
          end
        rescue JSON::ParserError, ArgumentError => e
          # Protect against JSON parse attacks
          @message = 'JSON parse failed'
          status = false
        end
      end
    end

    if status
      unless @respondent.persisted?
        @respondent.save
        @response.respondent = @respondent
        @response.save
      end
    else
      render json: ({success: false, message: 'invalid parameters'})
    end
    
    status
  end
end
