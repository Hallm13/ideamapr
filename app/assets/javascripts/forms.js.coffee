set_prompt = (css_select) ->
  window.selector = css_select
  if window.prompt_map
    prompt = window.prompt_map['data'][$('#survey_question_question_type option:selected').text()]
    $(css_select).text prompt
  else
    $.post('/ajax_api',
        'payload' : 'survey_question/get_prompt_map/'
      (d, s, x) -> 
        window.prompt_map = d
        set_prompt(window.selector) # recursion
    )
  
functions = ->
  set_prompt('#helper_edit')
  $('#survey_question_question_type').change( (evt) ->
    set_prompt('#helper_edit')
  )
$(document).on('page:load ready', functions)

