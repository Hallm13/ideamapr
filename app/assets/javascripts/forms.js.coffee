prompts = (inp) ->
  map =
    'Ranking' : 'Rank these ideas in order of importance'
    'Yea/Nay' : 'Mark the ideas in this list that you consider important'
  
  if map[inp]
    return map[inp]
  else
    return ''  
  
functions = ->
  $('#helper_edit').text(prompts($('#survey_question_question_type option:selected').text()))
  $('#survey_question_question_type').change( (evt) ->
    prompt = prompts($(evt.target).closest('#survey_question_question_type').find('option:selected').text())
    $('#helper_edit').text prompt
  )
$(document).on('page:load ready', functions)

