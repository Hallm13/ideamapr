IdeaMapr.Views.AdminAssignedQuestionListView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo @collection, 'sort', @render

  render: ->
    # The render will be called by the manager view that holds the selected and search views
    view_self = @
    # clear!
    @$el.html ''
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminAssignedQuestionView
        model: m
      view_self.$el.append(child_view.render().el)
    @render_finish '#admin-add-question-list'
    @
