Controller = ->
Controller.prototype = 
  set_length : (elt) ->
    if $(elt).val().length > 10
      $(elt).siblings('.builder-before').css('background-color', 'green')
    else
      $(elt).siblings('.builder-before').css('background-color', 'white')
          
window.controller = new Controller()
  
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

window.get_help_text = (state) ->
  $.get('/ajax_api?payload=cms/get/help_text',
    (d, s, x) ->
      window.help_text = d['data']
  )

functions = ->      
  set_prompt('#helper_edit')
  get_help_text()

  if $('.builder-box')
    $('.builder-box').each (idx, elt) ->
      id = $(elt).find('.hidden').data('box-id')
      new_elt = $('<div>').addClass('builder-before')
      new_elt.text id
      $(elt).prepend new_elt

      new_elt = $('<div>').addClass('builder-after')
      id = $(elt).find('.hidden').data('box-key')

      new_elt.text('?')
      $(elt).append new_elt
      new_elt.click (evt) ->
        help_box = $(elt).find('.help-text')
        if help_box.text() == ''
          help_box.text(window.help_text['help_text_'+id])
        help_box.toggle()
    $('#survey_question_question_type').change( (evt) ->
      set_prompt('#helper_edit')
    )

  $('.watched-box').keyup (evt) ->
    window.controller.set_length(this)
    
$(document).on('page:load ready', functions)

