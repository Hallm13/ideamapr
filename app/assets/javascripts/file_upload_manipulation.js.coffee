functions = ->
  $('#attachment-button').change (evt) ->
    f = $(evt.target).val()
    unless typeof f == 'undefined'
      s = f.match(/[^\\]+$/)[0]
      $('#fake-link .current-attachment').text(s)
    
  $('.attachment-div').click (evt) ->
    if $(evt.target).parent().attr('id') == 'fake-link'
      evt.stopPropagation()
      $('#attachment-button').click()

$(document).on('turbolinks:load', functions)
