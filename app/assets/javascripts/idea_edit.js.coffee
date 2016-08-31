idea_edit_functions = ->
  $('#idea_location').geocomplete()
  $('#idea_location').attr('placeholder', '')
  
  $('.attachment-desc .x-box').click (evt) ->
    parent = $(evt.target).closest('.attachment-desc')
    id = parent.data('attachment-id')
    $.post('/ajax_api',
        payload: 'idea/delete_attachment/' + id,
      (d, s, x) ->
        parent.detach()
    )
$(document).on('turbolinks:load', idea_edit_functions)
