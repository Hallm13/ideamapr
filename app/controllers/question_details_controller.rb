class QuestionDetailsController < ApplicationController
  def index
    if params[:for_survey_question] and qn = SurveyQuestion.find_by_id(params[:for_survey_question]) and
      qn.question_detail
      render json: (qn.question_detail.details_list.map do |qd_hash|
        {text: qd_hash['text'], idea_rank: qd_hash['idea_rank']}
      end)
    else
      render json: []
    end
  end
end
