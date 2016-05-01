IdeaMapr.Views.SurveyListAppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.model, "sync", this.render)

  render: ->
    view_self = this
    this.model.get('survey_list_collection').each (model) ->
      survey_view = new IdeaMapr.Views.SurveyView
        model: model

      survey_view.set_dropdown_choices view_self.model.get('allowed_states')
      row_view = survey_view.render().el
      view_self.$el.append row_view 
    this
