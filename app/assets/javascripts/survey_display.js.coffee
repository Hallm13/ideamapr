funcs = ->
  return if $('#survey_id').length == 0

  survey_id = $('#survey_id').data('survey-id')
  qn_type = $('#survey_question_data').data('question-type')
  
  sq_list = new IdeaMapr.Collections.SurveyQuestionCollection
  app = new IdeaMapr.Views.AppView(
    collection: sq_list,
    el: $('#app'),
  )

  # The data fetches trigger the events cascade
  # These two can run in parallel
  sq_list.getQuestions survey_id  
      
$(document).on('ready page:load', funcs)
