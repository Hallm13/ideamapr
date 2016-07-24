$(document).ready ->
  $('#attachment-button').change (evt) ->
    f = $(evt.target).val()
    unless typeof f == 'undefined'
      s = f.match(/[^\\]+$/)[0]
      $('#fake-link .current-attachment').text(s)
    
  $('.attachment-div').click (evt) ->
    if $(evt.target).attr('id') == 'fake-link'
      $('#attachment-button').click()
