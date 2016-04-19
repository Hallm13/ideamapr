funcs = ->
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

$(document).on('ready page:load', funcs)
