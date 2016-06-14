IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
    answered: false
    promoted: 0
    
  urlRoot: '/survey_question',
