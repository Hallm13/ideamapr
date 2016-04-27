class ProcessResponsesJob < ActiveJob::Base
  queue_as :default
  def perform(answer)
    payload = answer.payload
    qn_ids = payload.map do |qn|
      qn['sqn_id'].to_i
    end

    qn_lookup = SurveyQuestion.where('id in (?)', qn_ids).inject({}) do |acc, qn|
      acc[qn.id] = qn
      acc
    end

    # Normalize the IDs to integers and remove ideas that aren't valid
    reconstr_payload = payload.map do |qn|

      qn_rec = qn_lookup[qn['sqn_id'].to_i]
      idea_ids = qn_rec.ideas.pluck :id
      actual_answers = qn['answers'].select do |ans|
        idea_ids.include? ans['idea_id'].to_i
      end.map do |ans|
        ans['idea_id'] = ans['idea_id'].to_i
        ans
      end
      
      # Reconstruct the payload from the actual answers
      actual_qn_payload = {sqn_id: qn['sqn_id'].to_i, answers: actual_answers}
    end

    answer.payload = reconstr_payload
    answer.save
  end
end
