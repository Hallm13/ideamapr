IdeaMapr.Views.PublicIdeaListView = IdeaMapr.Views.IdeaListView.extend
  className: 'row'
  
  initialize: ->
    _.bindAll(@, 'render')
    @        
      
  render: ->
    viewself = @
    # clear!
    @$el.html ''
    @collection.each (m) ->
      child_view = new IdeaMapr.Views.PublicIdeaView
        model: m
      child_view.question_type = viewself.question_type
      viewself.$el.append(child_view.render().el)

    @
