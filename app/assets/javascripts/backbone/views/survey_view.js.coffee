IdeaMapr.Views.SurveyView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')

  render: ->
    this.$el.html(_.template($('#survey-listing-template').html())(this.model.rendering_data()))
    this
