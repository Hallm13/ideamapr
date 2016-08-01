require 'active_support/concern'
module SurveyReporting
  extend ActiveSupport::Concern
  included do
    # Instancee methods

    def full_report_hash
      ret = survey_hash
      ret[:full_details] = []

      survey_questions.includes(:ideas).where('survey_questions.question_type in (?)',
                                              [SurveyQuestion::QuestionType::PROCON, SurveyQuestion::QuestionType::NEW_IDEA,
                                              SurveyQuestion::QuestionType::TEXT_FIELDS]).all.each do |qn|
        ia_list = individual_answers.where(survey_question_id: qn.id)
        qn_stats_hash = {question_id: qn.id, question_title: qn.title, question_prompt: qn.question_prompt,
                         question_type: qn.question_type}
        case qn.question_type            
        when SurveyQuestion::QuestionType::PROCON
          qn_stats_hash.merge! SurveyReporting.full_procon_stats(ia_list)
        when SurveyQuestion::QuestionType::NEW_IDEA
          qn_stats_hash.merge! SurveyReporting.full_newidea_stats(ia_list)
        when SurveyQuestion::QuestionType::TEXT_FIELDS
          qn_stats_hash.merge! SurveyReporting.full_text_field_stats(ia_list)
        end

        ret[:full_details] << qn_stats_hash
      end

      ret
    end
    
    def report_hash
      ret = survey_hash
      ret[:answer_stats] = []

      survey_questions.includes(:ideas).all.each do |qn|
        ia_list = individual_answers.where(survey_question_id: qn.id)
        qn_stats_hash = {question_id: qn.id, question_title: qn.title, question_prompt: qn.question_prompt,
                         question_type: qn.question_type,
                         participation_rate: ia_list.size.to_f / responses.count, answer_rate: ia_list.count}
        
        idea_order = qn.ideas.order('idea_assignments.ordering asc').pluck :id, :title
        case qn.question_type            
        when SurveyQuestion::QuestionType::PROCON
          qn_stats_hash.merge! SurveyReporting.procon_stats(ia_list)
        when SurveyQuestion::QuestionType::RANKING
          qn_stats_hash.merge! SurveyReporting.ranking_stats(ia_list, idea_order)
        when SurveyQuestion::QuestionType::NEW_IDEA
          qn_stats_hash.merge! SurveyReporting.newidea_stats(ia_list)
        when SurveyQuestion::QuestionType::BUDGETING
          qn_stats_hash.merge! SurveyReporting.budgeting_stats(ia_list, qn.idea_assignments.order(ordering: :desc), idea_order)
        when SurveyQuestion::QuestionType::TOPPRI
          qn_stats_hash.merge! SurveyReporting.toppri_stats(ia_list, idea_order)
        when SurveyQuestion::QuestionType::RADIO_CHOICES
          qn_stats_hash.merge! SurveyReporting.radio_stats(ia_list)
        end

        ret[:answer_stats] << qn_stats_hash
      end

      ret
    end

    private
    def survey_hash
      { individual_answer_count: self.individual_answers.count,
        respondent_count: self.respondents.count,
        finish_count: self.responses.where(closed: true).count
      }
    end      
  end

  class_methods do
    # Class methods
  end

  def self.ranking_stats(ia_list, idea_order)
    rank_totals = {}
    ordered_totals = []
    ct = ia_list.count.to_f

    ia_list.each do |ia|
      response = ia.response_data
      response.each_with_index do |packet, rank|
        # component_rank is passed in, but is not necessary
        rank_totals[packet['idea_id']] ||= 0
        rank_totals[packet['idea_id']] += (rank + 1)
      end
    end
    rank_totals.keys.each do |idea_id|
      rank_totals[idea_id] /= ct
    end

    # Return stats in order ideas were assigned.
    idea_order.each do |id_title|
      ordered_totals << {title: id_title[1], avg: rank_totals[id_title[0]]}
    end
    
    {ranking_averages: ordered_totals}
  end

  def self.procon_stats(ia_list)
    # ia_list : AR relation
    totals = {}
    ia_list.each do |ia|
      ia.response_data.each do |idea_packet|
        pro_ct = idea_packet['type-0-data']['feedback']['pro'].size
        con_ct = idea_packet['type-0-data']['feedback']['con'].size

        idea = Idea.find_by_id idea_packet['idea_id']
        totals[idea.id] ||= {}
        totals[idea.id][:title] ||= idea.title
        
        totals[idea.id][:pro] ||= 0
        totals[idea.id][:con] ||= 0

        totals[idea.id][:pro] += pro_ct
        totals[idea.id][:con] += con_ct
      end
    end
    
    {procon_diffs: totals.keys.sort_by { |k| totals[k][:con] - totals[k][:pro]}.map do |idea_id|
      {idea_id: idea_id, pro_count: totals[idea_id][:pro], con_count: totals[idea_id][:con], title: totals[idea_id][:title]}
    end.sort_by { |rec| rec[:con_count] - rec[:pro_count] } }
  end
  
  def self.newidea_stats(ia_list)
    # number of submitted ideas total (and average submissions per person?)
    # \"data\":[{\"answered\":false,\"checked\":false,\"idea_id\":-1,\"title\":\"dummy\"},{\"answered\":false,\"checked\":false,\"title\":\"i dont know\",\"description\":\"123\"},{\"answered\":false,\"checked\":false,\"title\":\"you tell me \",\"description\":\"abc\"}]}"}
    total_ideas = ia_list.inject(0) do |sum, ia|
      sum += ia.response_data.size - 1 # One of the suggested ideas is a dummy model
      sum
    end
    average = total_ideas.to_f/ia_list.size
    
    {total_new_ideas: total_ideas, average_number_of_submissions: average}
  end

  def self.budgeting_stats(ia_list, assignments, idea_order)
    # Avg. spending on idea over all answers; and also just show the unit cost informationally
    # Sorted desc.
    # {\"data\":[{\"answered\":true,\"checked\":false,\"cart_count\":1,\"idea_id\":2},{\"answered\":false,\"checked\":false,\"idea_id\":3},{\"answered\":true,\"checked\":false,\"cart_count\":0,\"idea_id\":1},{\"answered\":true,\"checked\":false,\"cart_count\":1,\"idea_id\":4}]}
    total_spends = {}
    ia_list.each do |ia|
      ia.response_data.zip(assignments.to_a).map do |answer_assg|
        total_spends[answer_assg[1]['idea_id']] ||= 0
        if (x = answer_assg[0]['cart_count']) == 1
          # Trying to avoid multiplication here... is it helpful, or a silly optimization?
          total_spends[answer_assg[1]['idea_id']] += answer_assg[1].budget
        end
      end
    end
    
    idea_list = []
    respondent_ct = Respondent.count
    {sorted_idea_avg_budget: total_spends.map do |k, v|
       [k, (idea_order.select { |idea| idea[0] == k}.first[1] ),
        v.to_f / ia_list.length, assignments.where(idea_id: k).first.budget]
     end.sort_by { |pair| -1 * pair[2] }
    }
  end

  def self.toppri_stats(ia_list, idea_order)
    # # times idea was selected as top
    # {\"data\":[{\"answered\":false,\"checked\":false,\"idea_id\":3,\"component_rank\":0},{\"answered\":false,\"checked\":false,\"idea_id\":1,\"component_rank\":1}]}
    top_cts = {}
    ia_list.each do |ia|
      ia.response_data.each do |idea_rec|
        id = idea_rec['idea_id']
        if idea_rec['checked']
          top_cts[id] ||= 0
          top_cts[id] += 1
        end
      end
    end

    idea_list = []

    {sorted_idea_top_counts: top_cts.map do |k, v|
       [k, (idea_order.select { |idea| idea[0] == k}.first[1]), v]
     end.sort_by { |pair| -1 * pair[2] }
    }
  end
  
  def self.radio_stats(ia_list)
    # Show total counts for each selection, sorted desc.
    # {\"data\":[{\"answered\":true,\"checked\":false,\"text\":\"Hot\"},{\"answered\":true,\"checked\":false,\"text\":\"Warm\"},{\"answered\":true,\"checked\":true,\"text\":\"Lukewarm\"},{\"answered\":true,\"checked\":false,\"text\":\"Cold\"}]}

    radio_cts = {}
    ia_list.each do |ia|
      ia.response_data.each do |detail|
        text = detail['text']
        if detail['checked']
          radio_cts[text] ||= 0
          radio_cts[text] += 1
        end
      end
    end

    {sorted_radio_counts: radio_cts.map do |text, v|
       [text, v]
     end.sort_by { |pair| -1 * pair[1] }}
  end

  def self.full_procon_stats(ia_list)
    lists = {}    
    ia_list.each do |ia|
      ia.response_data.each do |idea_packet|
        pro_list = idea_packet['type-0-data']['feedback']['pro']
        con_list = idea_packet['type-0-data']['feedback']['con']
        idea = Idea.find_by_id idea_packet['idea_id']
        lists[idea.title] ||= {pro: [], con: []}

        pro_list.each do |pro|
          lists[idea.title][:pro] << ({respondent_id: ia.respondent_id, text: pro})
        end
        con_list.each do |con|
          lists[idea.title][:con] << ({respondent_id: ia.respondent_id, text: con})
        end
      end
    end
    
    {lists_by_idea: lists}
  end
  
  def self.full_newidea_stats(ia_list)
    {}
  end
  
  def self.full_text_field_stats(ia_list)
    {}
  end
end
