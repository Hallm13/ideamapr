IdeaMapr.Models.SurveyIndexModel = Backbone.Model.extend
  url: ->
    '/surveys'
  defaults:
    survey_list_collection: new IdeaMapr.Collections.SurveyCollection()
    allowed_states: []

  parse: (resp_obj) ->
    this.get('survey_list_collection').reset(resp_obj['data'])
    resp_obj
