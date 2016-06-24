module SurveyQuestionsHelper
  def survey_question_show?(question_obj, vb)
    status = true
    # Don't show this box for new survey qns because budgeting is the not the default choice 
    if vb.box_key == 'sq-set-budget' &&
       (question_obj.id.nil? || question_obj.question_type != SurveyQuestion::QuestionType::BUDGETING)
      status = false
    end
    # Show this box for new survey qns because idea choices are defaults
    if vb.box_key == 'sq-add-ideas' &&
       question_obj.question_type.present? &&
       (question_obj.question_type == SurveyQuestion::QuestionType::RADIO_CHOICES ||
        question_obj.question_type == SurveyQuestion::QuestionType::TEXT_FIELDS)
      status = false
    end
    
    if vb.box_key == 'sq-add-fields' &&
       (question_obj.id.nil? or
        (question_obj.question_type != SurveyQuestion::QuestionType::RADIO_CHOICES &&
         question_obj.question_type != SurveyQuestion::QuestionType::TEXT_FIELDS))
      status = false
    end
    status
  end
  
  def show_conditional(form_obj, vb)
    form_obj.is_a?(SurveyQuestion) ? (survey_question_show?(form_obj, vb)) : true
  end
  
  def fa_symbol
    {edit: 'pencil', view: 'eye', select: 'check'}
  end
  def action_target
    {edit: self.send("edit_#{@target_obj}_url".to_sym, @curr_obj),
     view: self.send("#{@target_obj}_url".to_sym, @curr_obj), select: @curr_obj.id}
  end
end
