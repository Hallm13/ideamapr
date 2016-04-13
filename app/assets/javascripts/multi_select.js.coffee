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
    container_match = window.location.href.match(/for_([_\w]+)=(\d+)/)
    container_name = container_match[1]
    obj_id = container_match[2]
    
    path = '/'+container_name+'s/' + obj_id + '/edit'
    arr = window.selected_ids.map (elt, idx) ->
      container_name + '[components][]=' + elt

    window.location = (path + '?' + arr.join('&'))
    null
    
$(document).on('page:load ready', functions)
