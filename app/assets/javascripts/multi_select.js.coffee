window.selected_ids = new Array

functions = ->
  $('.fa.active-icon').click( (evt) ->
    tid = $(this).data('action-target')

    # edit or view is a get request

    if typeof(tid)!='number' && tid.match(/^http/)!=null
      window.location.href = tid
    else
      pos = window.selected_ids.indexOf(tid)
      if pos == -1
        $(this).addClass('active-select')
        window.selected_ids.push tid
      else
        $(this).removeClass('active-select')
        window.selected_ids.splice(pos, 1)
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
