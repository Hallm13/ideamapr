# Some buttons need the click to trickle down to the contained <a> element
goto_child_a = ($d) ->
  link = $d.find('a')
  document.location.href = $(link).attr('href')

everything_functions = ->
  $('.secondary-item').click (evt) ->
    goto_child_a $(this)
  $('.goto-edit').click (evt) ->
    l = $(evt.target).closest('.goto-edit').data('goto-target')
    unless typeof l == 'undefined'
      # If there is a target, go to it.
      window.location.href = l
    
$(document).on('page:load ready', everything_functions)
