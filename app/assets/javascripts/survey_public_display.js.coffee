funcs = ->
  return if $.find('#survey_token').length == 0

  survey_token = $('#survey_token').data('survey-token')

  shown_survey = new IdeaMapr.Models.Survey()
  shown_survey.set('public_link', survey_token)
  sq_list = new IdeaMapr.Collections.PublicSurveyQuestionCollection()
  sq_list.survey_token = survey_token
  shown_survey.question_list = sq_list
  
  app = new IdeaMapr.Views.SurveyPublicView(
    model: shown_survey,
    collection: sq_list,
    el: $('#survey-public-view'),
  )

  # The data fetches trigger the events cascade
  # These two can run in parallel
  shown_survey.fetch()

  # SurveyPublicView listens to this collections and starts the rendering
  # process when it is fetched
  sq_list.fetch()
      
$(document).on('ready turbolinks:load', funcs)
