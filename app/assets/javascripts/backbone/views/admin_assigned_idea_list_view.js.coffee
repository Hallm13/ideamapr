IdeaMapr.Views.AdminAssignedIdeaListView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    # Super (in Backbone)
    IdeaMapr.Views.IdeaListView.prototype.initialize.call @
    @

  render: ->
    viewself = @
    # clear!
    @$el.html ''
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.AdminAssignedIdeaView
        model: m
      child_view.question_type = viewself.question_type
      viewself.$el.append(child_view.render().el)
      
    if @example_count > 0
      top_rank = 3 - @example_count
      for num in [0..@example_count-1]
        m = new IdeaMapr.Models.Idea()
        m.make_example
          rank: top_rank
        top_rank += 1
        child_view = new IdeaMapr.Views.AdminAssignedIdeaView
          model: m
        child_view.question_type = viewself.question_type
        @$el.append(child_view.render().el)
    @
