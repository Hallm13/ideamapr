bust_cache = (xhr) ->
  return true
  xhr.setRequestHeader('Content-Type', 'application/json')
  xhr.setRequestHeader('Cache-Control', 'no-store')
  
idea_list_functions = ->  
  coll = new IdeaMapr.Collections.IdeaCollection()
  list_view = new IdeaMapr.Views.AdminAssignedIdeaListView(
    collection: coll
    el: $('#idea-list-container')
  )
  list_view.admin_view = true
  list_view.question_type = -1
  coll.fetch
    beforeSend: bust_cache
  
$(document).on('turbolinks:load', idea_list_functions)
