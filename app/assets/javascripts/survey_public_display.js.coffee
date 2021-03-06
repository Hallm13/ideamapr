funcs = ->
  return if $.find('#survey_token').length == 0
  if $('#survey_status').val() != '1'
    alert 'This survey is not published'
    return true
    
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

  # 127 - close dropdown for all clicks
  $(document).click (evt) ->
    app.close_survey_navbar()  
      
$(document).on('ready turbolinks:load', funcs)
