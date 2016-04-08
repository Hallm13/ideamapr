module SurveyQuestionsHelper
  def edit_or_select(q)
    output = '<div class="cell-1'
    output += selector_radio q

    if @survey.nil?
      output += (link_to '> Edit', edit_survey_question_url(q, step_command: :idea_add))
    else
      output += "> Select"
    end

    output += '</div>'
    raw output
  end

  def selector_radio(q)
    output = ''
    unless @survey.nil?
      output += " selector-control\" data-target-id=#{q.id}>"
      output += "<input style='float:right;' type=checkbox class='selector-checkbox'></input>"
    else
      output += '">'
    end
    
    output
  end
end
