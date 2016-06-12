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
    should_delete = opts[:should_delete].nil? ? false : opts[:should_delete]
    
    added_table = model.constantize.table_name
    thru_model_table = through_model.constantize.table_name
    current_obj_thru_recs = obj.send("#{thru_model_table}")
    
    if !should_delete
      existing_ids = obj.send("#{added_table}".to_sym).pluck(:id)
      add_ids = model_ids - existing_ids

      #TODO - do something like remove_ids = existing_ids - model_ids; and use it to smartly remove existing assignments
    else
      current_obj_thru_recs.send(:all).send(:each) { |r| r.delete}
      add_ids = model_ids
    end

    # Clean the add_ids so spurious ones are ignored
    possible_ids = model.constantize.send(:where, 'id in (?)', add_ids).pluck(:id)
    add_ids = add_ids - (add_ids - possible_ids)

    thru_model_ar = through_model.constantize

    # If there are existing has_many records, ordered in some way, then find the highest known order
    if thru_model_ar.send(:new).respond_to? :ordering
      order_ctr =
        (should_delete || (ex_last = current_obj_thru_recs.send(:order, ({ordering: :desc})).first&.send(:ordering)).nil?) ?
          0 : ex_last + 1
      else
        order_ctr = nil
      end

    thru_model_ar.send(:import,
                       add_ids.map do |id|
                         nm = thru_model_ar.send(:new)
                         nm.send("#{model.underscore}_id=", id)
                         unless order_ctr.nil?
                           nm.send("ordering=", order_ctr) 
                           order_ctr += 1
                         end
                         
                         nm.send("#{fkey}=", obj.id)
                         if polymorphic_type
                           nm.send((fkey.gsub(/_id/, '') + '_type=').to_sym, polymorphic_type)
                         end
                         nm
                       end
                      )

    true
  end
end
