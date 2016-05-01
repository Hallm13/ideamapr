funcs = ->
  survey_list = new IdeaMapr.Models.SurveyIndexModel()
  survey_list.fetch()
      
  app = new IdeaMapr.Views.SurveyListAppView(
    model: survey_list,
    el: $('#survey-list-app'),
  )

      
$(document).on('ready page:load', funcs)
