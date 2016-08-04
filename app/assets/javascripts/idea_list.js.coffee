idea_list_functions = ->
  coll = new IdeaMapr.Collections.IdeaCollection()
  list_view = new IdeaMapr.Views.AdminAssignedIdeaListView(
    collection: coll
    el: $('#idea-list-container')
  )
  list_view.admin_view = true
  list_view.question_type = -1
  coll.fetch()
  
$(document).on('turbolinks:load', idea_list_functions)
