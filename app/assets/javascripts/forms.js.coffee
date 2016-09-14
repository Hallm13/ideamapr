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
  
set_expected_color = (tgt) ->
  exp_length = $(tgt).data('expected-length')
  if exp_length != -1 and $(tgt).val().trim().length >= exp_length
      $(tgt).css('background-color', '#DFF2C2')
    else
      $(tgt).css('background-color', '#FFF')

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
    $('html, body').animate(
        scrollTop: $(error_list[0]).offset().top - 100
      , 500
    )
    false
  else
    true

forms_functions = ->
  $('.validated-box').focus (evt) ->
    $('.error-box').hide('medium')
    
  $('.validated-box').keyup (evt) ->
    set_expected_color evt.target
    
  if $('.builder-box').length != 0
    # initialize the page.
    $('form#container_update #redirect').val('')
    $('input,textarea').each (idx, elt) ->
      if $(elt).val().trim().length > 0
        $(elt).addClass('with-text')
      if $(elt).hasClass('validated-box')
        set_expected_color elt
        
      $(elt).keyup (evt) ->
        if $(elt).val().trim().length == 0
          $(elt).removeClass('with-text')
        else
          $(elt).addClass('with-text')

    # This code no longer has a UI element to respond to
    $('.builder-after').click (evt) ->
      help_box = $(this).closest('.builder-box').find('.help-text')
      id = $(this).closest('.builder-box').find('.hidden').data('box-key')
  
      if help_box.text() == ''
        candid = window.cms_list.where({key: 'help_text_'+id})
        if candid.length > 0
          help_box.text(candid[0].get('cms_text'))
        else
          help_box.text 'No help text supplied'
          
      help_box.toggle()
      
$(document).ready(forms_functions)
$(document).on('turbolinks:load', forms_functions)
