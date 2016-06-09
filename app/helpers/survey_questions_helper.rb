module SurveyQuestionsHelper
  def survey_question_conditionals(question_obj, vb)
    # Don't show this box for new survey qns because budgeting is the not the default choice 
    if vb.box_key == 'sq-set-budget' &&
       question_obj.id.nil? || question_obj.question_type != SurveyQuestion::QuestionType::BUDGETING
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
  end
  
  def hide_conditional(form_obj, vb)
    status = true
    case form_obj.class
    when SurveyQuestion
      status = survey_question_conditionals form_obj, vb
    else
      status = true
    end
    
    status
  end    
  def hide_by_contained(contained, container)
    # generate a hidden class for contained objects in an index that are already contained
    # in their container

    if container
      target_assoc = (contained.is_a?(Idea)) ? 'ideas' : 'survey_questions'
      if container.respond_to?(target_assoc) &&
         (container.send(target_assoc)).all.include?(contained)
        'myhidden'
      else
        ''
      end
    else
      ''
    end
  end
  
  def edit_or_select(q_or_i)
    @curr_obj = q_or_i
    @target_obj = (q_or_i.is_a?(Idea)) ? 'idea' : 'survey_question'
    
    output = '<div class="cell-1">'

    in_select = ((params[:controller] == 'survey_questions' && !@survey.nil?) or
      (params[:controller] == 'ideas' && !@question.nil?))

    output += set_icon(:select, in_select) + set_icon(:edit, in_select) + set_icon(:view, in_select) 

    output += '</div>'
    raw output
  end

  def set_icon(type, in_select)
    output = ''
    output += "<i class='fa fa-#{fa_symbol[type]}"
    active = (in_select && type == :select) || (!in_select && type!= :select)

    output += active ? ' active-icon' : ' inactive-icon'
    output += "' data-action-target='#{action_target[type]}'></i>"

    
    output
  end

  def fa_symbol
    {edit: 'pencil', view: 'eye', select: 'check'}
  end
  def action_target
    {edit: self.send("edit_#{@target_obj}_url".to_sym, @curr_obj),
     view: self.send("#{@target_obj}_url".to_sym, @curr_obj), select: @curr_obj.id}
  end
end
