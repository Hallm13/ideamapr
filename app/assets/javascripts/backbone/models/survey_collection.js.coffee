IdeaMapr.Collections.SurveyCollection = Backbone.Collection.extend
  defaults: ->
  model: IdeaMapr.Models.Survey,
  urlRoot: '/surveys',
  url: ->
    this.urlRoot
