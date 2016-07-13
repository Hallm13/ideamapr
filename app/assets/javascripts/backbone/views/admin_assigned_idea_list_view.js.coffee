IdeaMapr.Views.AdminAssignedIdeaListView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo @collection, 'sort', @render
    
  render: ->
    # The render will be called by the manager view that holds the selected and search views
    view_self = @
    # clear!
    @$el.html ''

    available_slots = 3
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminAssignedIdeaView
        model: m
      available_slots -= 1
      child_view.question_type = view_self.question_type
      view_self.$el.append(child_view.render().el)

    @add_example_views
      available_slots: available_slots
      type: 'idea'
      $root: @$el
    @
