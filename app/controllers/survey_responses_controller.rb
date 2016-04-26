class SurveyResponsesController < ApplicationController
  def update
    if request.xhr?
      render json: ({'status' => true})      
    end
  end
end
