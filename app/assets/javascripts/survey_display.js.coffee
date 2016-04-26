funcs = ->
  return if $('#survey_data').length == 0
  
  idea_list = new IdeaMapr.Collections.IdeaCollection
  survey_id = $('#survey_data').data('survey-id')
  qn_type = $('#survey_question_data').data('question-type')
  
  sq_list = new IdeaMapr.Collections.SurveyQuestionCollection

  app = new IdeaMapr.Views.AppView(
    collection: sq_list,
    el: $('#app'),
  )
  # When the master idea list is updated, clone its contents into each survey question's model
  sq_list.listenTo idea_list, 'update', sq_list.clone

  # The data fetches trigger the events cascade
  # These two can run in parallel
  sq_list.getQuestions survey_id  
  idea_list.getSurveyIdeas survey_id
  
  $('#save-response').click ->
    idea_list.save()
    
$(document).on('ready page:load', funcs)
