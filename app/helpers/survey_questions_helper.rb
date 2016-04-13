module SurveyQuestionsHelper
  def edit_or_select(q)
    @curr_q = q
    output = '<div class="cell-1">'

    in_select = !@survey.nil?
    output += set_icon(:view, in_select) + set_icon(:edit, in_select) + set_icon(:select, in_select)

    output += '</div>'
    raw output
  end

  def set_icon(type, in_select)
    output = ''
    output += "<i class='fa fa-#{fa_symbol[type]}"
    active = (in_select && type == :select) || (!in_select && type!= :select)

    output += active ? ' active-icon' : ' '
    output += "' data-action-target='#{action_target[type]}'></i>"

    
    output
  end

  def fa_symbol
    {edit: 'pencil', view: 'eye', select: 'check'}
  end
  def action_target
    {edit: edit_survey_question_url(@curr_q), view: survey_question_url(@curr_q), select: @curr_q.id}
  end
end
