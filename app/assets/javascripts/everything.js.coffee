goto_child_a = ($d) ->
  link = $d.find('a')
  document.location.href = $(link).attr('href')

functions = ->
  $('.secondary-item').click (evt) ->
    goto_child_a $(this)
  $('.btn-primary').click (evt) ->
    goto_child_a $(this)
      
$(document).on('page:load ready', functions)
