funcs = ->
  idea = new IdeaMapr.Models.Idea
  survey_id = $('#survey_data').data('survey-id')
  idea.getSurveyIdea(survey_id)
  $('#test').html(survey_id)
  
  survey_ideas = new IdeaMapr.Views.IdeaView(
    el: $('#idea-list'),
    model: idea
  )

$(document).on('ready page:load', funcs)
