# App for the survey index page for admins
funcs = ->
  survey_list = new IdeaMapr.Collections.SurveyIndexList()
  app = new IdeaMapr.Views.SurveyListAppView(
    collection: survey_list,
    el: $('#survey-list-app'),
  )
  survey_list.fetch()
      
$(document).on('ready page:load', funcs)
