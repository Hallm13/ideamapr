Controller = ->
Controller.prototype = 
  check_length : (elt) ->
    if $(elt).val().length > 10
      $(elt).closest('.relative-container').siblings('.builder-before').css('background-color', '#8af181')
    else
      $(elt).closest('.relative-container').siblings('.builder-before').css('background-color', 'white')
          
window.controller = new Controller()

# Set the helper text for question types  
set_prompt = (css_select) ->
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
        set_prompt(window.selector) # recursion
    )

functions = ->
  if $('.builder-box').length != 0
    # initialize the page.
    set_prompt('#helper_edit')

    $('form#container_update #redirect').val('')
    $('.builder-box').each (idx, elt) ->
      new_elt = $(elt).find('.builder-before')
      id = $(elt).find('.hidden').data('box-id')
      new_elt.text id
      
    $('.watched-box').each (idx, elt) ->
      window.controller.check_length elt

    $('input').each (idx, elt) ->
      if $(elt).val().trim().length > 0
        $(elt).addClass('with-text')
      $(elt).keyup (evt) ->
        if $(elt).hasClass('watched-box')
          window.controller.check_length(elt)

        if $(elt).val().trim().length == 0
          $(elt).removeClass('with-text')
        else
          $(elt).addClass('with-text')

    fade_on_delete = ($elt) ->
      (d, s, x) ->        
        if d['status'] == 'success'
          $elt.hide(500)
          $elt.remove()
    $('.delete-box').click (evt) ->
      survey_id = $('#survey_id').val()
      qn_box = $(evt.target).closest('.question-box')      
      delete_qn_id = qn_box.find('#survey_components_').val()

      # this ajax call will always return success by design.
      $.post('/ajax_api',
        'payload' : 'survey/delete_survey_question/' + survey_id + '/' + delete_qn_id
        fade_on_delete(qn_box)
        
    )
      
  
    $('.builder-after').click (evt) ->
      help_box = $(this).closest('.builder-box').find('.help-text')
      id = $(this).closest('.builder-box').find('.hidden').data('box-key')
  
      if help_box.text() == ''
          help_box.text(window.cms_list.where({key: 'help_text_'+id})[0].get('cms_text'))
      help_box.toggle()
      
    $('#survey_question_question_type').change( (evt) ->
      set_prompt('#helper_edit')
    )

    # Enable a transition from containeR to containeD
    $('#select-contained').click (evt) ->
      btn = $(evt.target)
      $('form#container_update #redirect').val('goto-contained')
      $('form#container_update').submit
          
$(document).on('page:load ready', functions)

