module RelationalLogic
  def handle_question_request(params)
    # The request can either contain a list of ideas that takes precedence and dynamically creates a question
    # With those ideas, or an ID of an existing question

    return if @survey.nil? or (params.keys.sort != [:idea_list, :question_type] and
      params.keys != [:with_survey_question])
    qn = nil
    
    if params[:idea_list] and SurveyQuestion.valid_type?(params[:question_type])
      # Forces the selection of actual records given any possible unclean list of IDs from the scary Internet.
      cleaned_idea_ids = Idea.where('id in (?)', params[:idea_list]).pluck(:id)
      if !cleaned_idea_ids.blank?
        ActiveRecord::Base.transaction do
          qn = SurveyQuestion.create title: SurveyQuestion::QuestionType.default_title(params[:question_type]),
                                     question_type: params[:question_type]
          
          raw_execute(:multi_idea_add, qn, cleaned_idea_ids)
        end
      end
    else
      qn = SurveyQuestion.find_by_id(params[:with_survey_question])
    end
    
    @survey.survey_questions << qn unless qn.nil?
  end

  def update_has_many!(obj, model, through_model, model_ids, opts = {})
    # obj has_many model's (through ...), update to reflect model_ids instead
    fkey = opts[:foreign_key] || "#{obj.class.to_s.underscore}_id"
    polymorphic_type = opts[:polymorphic] ? obj.class : nil

    added_table = model.constantize.table_name
    existing_ids = obj.send("#{added_table}".to_sym).pluck(:id)

    remove_ids = existing_ids - model_ids
    add_ids = model_ids - existing_ids

    # Clean the add_ids so spurious ones are ignored
    possible_ids = model.constantize.send(:where, 'id in (?)', add_ids).pluck(:id)
    add_ids = add_ids - (add_ids - possible_ids)

    thru_model_ar = through_model.constantize
    thru_model_ar.send(:import,
                       add_ids.map do |id|
                         nm = thru_model_ar.send(:new)
                         nm.send("#{model.underscore}_id=", id)
                         nm.send("#{fkey}=", obj.id)
                         if polymorphic_type
                           nm.send((fkey.gsub(/_id/, '') + '_type=').to_sym, polymorphic_type)
                         end
                         nm
                       end
                      )

    del_cands = thru_model_ar.send(:where, "#{model.underscore}_id in (?)", remove_ids)
    del_cands.map &:delete

    true
  end
end
