module RelationalLogic
  def handle_question_request(params)
    # The request can either contain a list of ideas that takes precedence and dynamically creates a question
    # With those ideas, or an ID of an existing question

    qn = nil
    if params[:idea_list]
      # Forces the selection of actual records given any possible unclean list of IDs from the scary Internet.
      cleaned_idea_ids = Idea.where('id in (?)', params[:idea_list]&.split(/,/)).pluck(:id)
      if !cleaned_idea_ids.blank?
        ActiveRecord::Base.transaction do
          qtype_class = "SurveyQuestion::QuestionType::#{params[:question_type].upcase}".constantize
          qn = SurveyQuestion.create title: SurveyQuestion::QuestionType.default_title(qtype_class),
                                     question_type: qtype_class
          
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

    fkey = opts[:foreign_key] || "#{obj.class.underscore}_id"
    polymorphic_type = opts[:polymorphic] ? obj.class : nil
    
    existing_ids = obj.send("#{model.constantize.table_name}".to_sym).pluck(:id)
    remove_ids = existing_ids - model_ids

    add_ids = model_ids - existing_ids
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
  end
end
