IdeaMapr.Collections.SurveyIndexList = Backbone.Collection.extend
  url: ->
    '/surveys'
  defaults:
    allowed_states: []
  model: IdeaMapr.Models.Survey
