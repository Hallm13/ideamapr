class SurveyResponsesController < ApplicationController
  def update
    if request.xhr?
      saved = save_response params
      if saved
        render json: ({'status' => true}), status: 201
      else
        render json: ({'status' => false}), status: 500
      end
    end
  end

  private
  def save_response(hash)
    status = false
    if hash[:survey_id] and
      hash[:responses]
      if (@survey = Survey.find_by_id(hash[:survey_id]))
        if hash[:cookie]
          r = Respondent.find_by_cookie_key hash[:cookie_key]
        end

        resps = filtered_responses hash[:responses]
        if resps.length > 0
          answer = Response.new respondent: r, survey: @survey, payload: resps
          status ||= answer.valid?
          if status
            answer.save
            ProcessResponsesJob.perform_later answer
          end
        end
      end
    end

    status
  end

  def filtered_responses(resp_hash)
    # Protect against IDs being passed through for questions that are not part of this survey
    output = []

    qn_ids = resp_hash.map do |qn|
      qn['sqn_id'].to_i
    end

    qn_ids_avlbl = @survey.survey_questions.pluck(:id)
    qn_ids_filtered = qn_ids_avlbl - (qn_ids_avlbl - qn_ids)

    # Only return survey questions in the answer that belong to this survey
    resp_hash.select do |qn|
      qn_ids_filtered.include? qn['sqn_id'].to_i
    end
  end
    
end
