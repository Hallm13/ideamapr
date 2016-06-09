# Set the helper text for question types  
window.set_prompt = (css_select) ->
  if typeof(window.cms_list) == 'undefined'
    window.cms_list = new IdeaMapr.Models.CmsList()
  cms_list.search_filter = 'help_text'
  cms_list.getById()

  window.selector = css_select
  if window.prompt_map
    prompt = window.prompt_map['data'][$('#survey_question_question_type option:selected').text()]
    $(css_select).text prompt
  else
    $.post('/ajax_api',
        'payload' : 'survey_question/get_prompt_map/'
      (d, s, x) -> 
        window.prompt_map = d
        window.set_prompt(window.selector) # recursion
    )

show_error_boxes = (arr_elts) ->
  arr_elts.forEach (e, i) -> 
    error_boxes = $(e).find('+ .error-box')
    if error_boxes.length == 0
      $(e).after($('<div>').addClass('error-box'))
      error_box = $(e).find('+ .error-box')
    else
      error_box = error_boxes[0]

    $(error_box).text('This box does not validate.')
    $(error_box).show()
  true

window.run_validations = ->
  all_valid = true
  error_list = []
  $('input.validated-box,textarea.validated-box').each (idx, elt) ->
    this_valid = $(elt).val().trim().length >= $(elt).data('expected-length')
    all_valid = all_valid && this_valid
    if !this_valid
      error_list.push elt

  if !all_valid
    show_error_boxes error_list
    false
  else
    true

functions = ->
  $('.validated-box').focus (evt) ->
    $('.error-box').hide('medium')
    
  $('.validated-box').keyup (evt) ->
    exp_length = $(evt.target).data('expected-length')
    if $(evt.target).val().trim().length >= exp_length
      $(evt.target).css('background-color', '#DFF2C2')
    else
      $(evt.target).css('background-color', '#FFF')
    
  if $('.builder-box').length != 0
    # initialize the page.
    window.set_prompt('#helper_edit')

    $('form#container_update #redirect').val('')
    $('input,textarea').each (idx, elt) ->
      if $(elt).val().trim().length > 0
        $(elt).addClass('with-text')
      $(elt).keyup (evt) ->
        if $(elt).val().trim().length == 0
          $(elt).removeClass('with-text')
        else
          $(elt).addClass('with-text')
  
    $('.builder-after').click (evt) ->
      help_box = $(this).closest('.builder-box').find('.help-text')
      id = $(this).closest('.builder-box').find('.hidden').data('box-key')
  
      if help_box.text() == ''
          help_box.text(window.cms_list.where({key: 'help_text_'+id})[0].get('cms_text'))
      help_box.toggle()
      
$(document).on('page:load ready', functions)

