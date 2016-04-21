funcs = ->
  return if $('#survey_data').length == 0
  
  ideaList = new IdeaMapr.Collections.IdeaCollection
  survey_id = $('#survey_data').data('survey-id')
  qn_type = $('#survey_question_data').data('question-type')
  ideaList.getSurveyIdeas(survey_id)

  idea_list_view = new IdeaMapr.Views.IdeaListView
    collection: ideaList
  idea_list_view.set_type qn_type
    
  app = new IdeaMapr.Views.AppView(
    el: $('#idea-list'),
  )
  app.render()
  app.append_idea idea_list_view
  $('#save-response').click ->
    ideaList.save()
    
$(document).on('ready page:load', funcs)
