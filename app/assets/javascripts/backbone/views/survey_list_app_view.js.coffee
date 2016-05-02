IdeaMapr.Views.SurveyListAppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.model, "sync", this.render)
    this.row_views = []

  shut_dropdowns: (view_cid) ->
    _.each this.row_views, (elt, idx) ->
      if elt.cid != view_cid
        elt.shut_dropdown()
          
  render: ->
    view_self = this
    this.model.get('survey_list_collection').each (model) ->
      survey_view = new IdeaMapr.Views.SurveyView
        model: model

      survey_view.set_dropdown_choices view_self.model.get('allowed_states')
      row_view = survey_view.render().el

      view_self.row_views.push survey_view
      view_self.listenTo(survey_view, 'survey_view:dropdown_click', view_self.shut_dropdowns)
      view_self.$el.append row_view 
    this
