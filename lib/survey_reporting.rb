require 'active_support/concern'
module SurveyReporting
  extend ActiveSupport::Concern
  included do
    # Instance methods
    def report_hash
      ret = survey_hash

      ret[:answer_stats] = []
      survey_questions.includes(:ideas).all.each do |qn|
        ia_list = individual_answers.where(survey_question_id: qn.id)
        qn_stats_hash = {question_id: qn.id}
        
        case qn.question_type            
        when SurveyQuestion::QuestionType::PROCON
          qn_stats_hash.merge! SurveyReporting.procon_stats(ia_list)
        when SurveyQuestion::QuestionType::RANKING
          idea_order = qn.ideas.order('idea_assignments.ordering asc').pluck :id
          qn_stats_hash.merge! SurveyReporting.ranking_stats(ia_list, idea_order)
        when SurveyQuestion::QuestionType::NEW_IDEA
          qn_stats_hash.merge! SurveyReporting.newidea_stats(ia_list)
        when SurveyQuestion::QuestionType::BUDGETING
          qn_stats_hash.merge! SurveyReporting.budgeting_stats(ia_list)
        when SurveyQuestion::QuestionType::TOPPRI
          qn_stats_hash.merge! SurveyReporting.toppri_stats(ia_list)
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
      puts ia.response_data
      puts ia.id
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
    idea_order.each do |id|
      ordered_totals << rank_totals[id]
    end
    
    {ranking_averages: ordered_totals}
  end

  def self.procon_stats(ia_list)
    # ia_list : AR relation
    totals = {}
    ia_list.each do |ia|
      if ia.response_data.nil?
        binding.pry
      end
      
      ia.response_data.each do |idea_packet|
        pro_ct = idea_packet['type-0-data']['feedback']['pro'].size
        con_ct = idea_packet['type-0-data']['feedback']['con'].size

        idea_id = idea_packet['idea_id']
        totals[idea_id] ||= {}
        totals[idea_id]['pro'] ||= 0
        totals[idea_id]['con'] ||= 0

        
        totals[idea_id]['pro'] += pro_ct
        totals[idea_id]['con'] += con_ct
      end
    end
    
    {procon_diffs: totals.keys.sort_by { |k| totals[k]['con'] - totals[k]['pro']}.map do |idea_id|
      {idea_id: idea_id, pro_count: totals[idea_id]['pro'], con_count: totals[idea_id]['con']}
    end}
  end
  
  def self.newidea_stats(ia_list)
    # number of submitted ideas total (and average submissions per person?)
    {}
  end

  def self.budgeting_stats(ia_list)
    # Avg. spending on idea over all answers; and also just show the unit cost informationally
    # Sorted desc.
    {}
  end

  def self.toppri_stats(ia_list)
    # # times idea was selected as top
    {}
  end
  
  def self.radio_stats(ia_list)
    # Show total counts for each selection, sorted desc.
    {}
  end
end
