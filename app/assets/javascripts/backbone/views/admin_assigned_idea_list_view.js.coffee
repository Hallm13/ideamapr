IdeaMapr.Views.AdminAssignedIdeaListView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo @collection, 'sort', @render
    @listenTo @collection, 'sync', @render
    @admin_view = false    
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
      if view_self.admin_view
        child_view.add_admin_events()
      
      view_self.$el.append(child_view.render().el)

    @add_example_views
      available_slots: available_slots
      type: 'idea'
      $root: @$el

    if @admin_view
      @xbox_handler.call()
    else
      @render_finish '#admin-add-idea-list'
    @

  attach_xbox_handler: (handler) ->
    # when the list of ideas is shown in the index view, we need to pass thru the x-box handling function
    # that is defined in javascripts/lists.js
    
    @xbox_handler = handler
    
