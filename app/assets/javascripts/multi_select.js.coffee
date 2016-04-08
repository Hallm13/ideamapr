window.selected_ids = new Array

functions = ->
  $('.selector-control').click( (evt) ->
    box = $(this).find('input[type=checkbox]')
    tid = $(this).data('target-id')

    pos = window.selected_ids.indexOf(tid)
    if $(box).is(':checked')
      $(box).prop('checked', false)
      if pos != -1
        window.selected_ids.splice(pos, 1)
    else
      $(box).prop('checked', true)
      window.selected_ids.push tid
  )
  $('#add-multi-select').click (evt) ->
    matches = window.location.href.match(/for_survey=(\d+)/)
    survey_id = matches[1]
    
    path = '/surveys/' + survey_id + '/edit'
    arr = window.selected_ids.map (elt, idx) ->
      'survey[qns][]=' + elt


    window.location = (path + '?' + arr.join('&'))
    null
    
$(document).on('page:load ready', functions)
