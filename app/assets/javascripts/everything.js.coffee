# for sq and survey edits, absorb clicks inside the unassigned box so we can let clicks outside it close that box
window.unassigned_closer = ->
  $('.unassigned-components').click (evt) ->
    evt.stopPropagation()
  $('body').click (evt) ->
    $('.unassigned-components').hide()
    
# Some buttons need the click to trickle down to the contained <a> element
goto_child_a = ($d) ->
  link = $d.find('a')
  if link.length > 0
    document.location.href = $(link).attr('href')

everything_functions = ->
  $('.secondary-item').click (evt) ->
    goto_child_a $(this)
  $('.goto-edit').click (evt) ->
    l = $(evt.target).closest('.goto-edit').data('goto-target')
    unless typeof l == 'undefined'
      # If there is a target, go to it.
      window.location.href = l
    
$(document).on('turbolinks:load ready', everything_functions)
