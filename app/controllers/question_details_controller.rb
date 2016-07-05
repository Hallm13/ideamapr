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

  def create
    if params[:_json]
      req_obj = params[:_json]
      details_list = req_obj.map { |h| h['text'] }
      qn_id = params[:for_survey_question]

      if qn_details = QuestionDetail.find_by_survey_question_id(qn_id)
        qn_details.delete
      end

      qn_details = QuestionDetail.create(survey_question_id: qn_id, details_list: details_list)
      
      render json: ({status: 'success', data: {question_id: qn_id}})
    end
  end
  
end
