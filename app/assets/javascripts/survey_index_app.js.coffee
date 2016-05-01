funcs = ->
  survey_list = new IdeaMapr.Collections.SurveyCollection()
  survey_list.fetch()
      
  app = new IdeaMapr.Views.SurveyListAppView(
    collection: survey_list,
    el: $('#survey-list-app'),
  )

      
$(document).on('ready page:load', funcs)
