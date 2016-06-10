IdeaMapr.Views.SurveyListAppView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, "sync", @render)
    @row_views = []

  shut_dropdowns: (view_cid) ->
    _.each @row_views, (elt, idx) ->
      if elt.cid != view_cid
        elt.shut_dropdown()
          
  render: ->
    view_self = @
    @$el.html('')
    
    @collection.each (model) ->
      model.admin_mode = true
      survey_view = new IdeaMapr.Views.SurveyView
        model: model

      row_view = survey_view.render().el
      view_self.listenTo(survey_view, 'survey_view:dropdown_click', view_self.shut_dropdowns)
      view_self.$el.append row_view
    @
