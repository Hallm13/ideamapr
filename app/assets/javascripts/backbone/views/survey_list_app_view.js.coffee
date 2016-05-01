IdeaMapr.Views.SurveyListAppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "sync", this.render)

  render: ->
    view_self = this
    this.collection.each (model) ->
      survey_view = new IdeaMapr.Views.SurveyView
        model: model
        
      view_self.$el.append(survey_view.render().el)
    this
