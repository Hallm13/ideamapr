funcs = ->
  return if $('#survey_token').length == 0

  survey_id = $('#survey_token').data('survey-token')

  shown_survey = new IdeaMapr.Models.Survey()
  shown_survey.set('public_link', survey_id)
  sq_list = new IdeaMapr.Collections.SurveyQuestionCollection
  app = new IdeaMapr.Views.SurveyPublicView(
    model: shown_survey,
    collection: sq_list,
    el: $('#survey-public-view'),
  )

  # The data fetches trigger the events cascade
  # These two can run in parallel
  shown_survey.fetch()

  # SurveyPublicView listens to this collections and starts the rendering
  # process when it is fetched.
  sq_list.getQuestions survey_id
      
$(document).on('ready page:load', funcs)
