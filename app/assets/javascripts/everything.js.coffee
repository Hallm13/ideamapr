functions = ->
  $('.secondary-item').click (evt) ->
    link = $(this).find('a')
    document.location.href = $(link).attr('href')
    
$(document).on('page:load ready', functions)
