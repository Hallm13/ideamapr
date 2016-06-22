IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
    view_request: 0
    answered: false
    promoted: 0
    
  urlRoot: '/survey_question',
