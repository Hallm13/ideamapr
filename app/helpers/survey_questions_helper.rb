module SurveyQuestionsHelper
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
