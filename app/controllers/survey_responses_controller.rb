class SurveyResponsesController < ApplicationController
  def update
    Rails.logger.debug params['survey_response']['_json']

    if request.xhr?
      render json: ({'status' => true})      
    end
  end
end
