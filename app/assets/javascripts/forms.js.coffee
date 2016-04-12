window.cms_text = new IdeaMapr.Models.CmsModel()
window.cms_list = new IdeaMapr.Models.CmsList()
cms_list.search_filter = 'help_text'
cms_list.getById()

Controller = ->
Controller.prototype = 
  set_length : (elt) ->
    if $(elt).val().length > 12
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

functions = ->
  # initialize the page.
  set_prompt('#helper_edit')

  if $('.builder-box')
    $('.builder-box').each (idx, elt) ->
      new_elt = $(elt).find('.builder-before')
      id = $(elt).find('.hidden').data('box-id')
      new_elt.text id
      
    $('.watched-box').each (idx, elt) ->
      window.controller.set_length elt

    $('.builder-after').click (evt) ->
      help_box = $(this).closest('.builder-box').find('.help-text')
      id = $(this).closest('.builder-box').find('.hidden').data('box-key')
  
      if help_box.text() == ''
          help_box.text(window.cms_list.where({key: 'help_text_'+id})[0].get('cms_text'))
      help_box.toggle()
      
    $('#survey_question_question_type').change( (evt) ->
      set_prompt('#helper_edit')
    )

    # Enable a transition from survey to survey question
    $('#select-question').click (evt) ->
      btn = $(evt.target)
      $('form#survey_update #redirect').val('select-question')
      $('form#survey_update').submit
      
  $('.watched-box').keyup (evt) ->
    window.controller.set_length(this)
    
$(document).on('page:load ready', functions)

