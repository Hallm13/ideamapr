# Base class for AdminAssignedIdeaListView, AdminSearchIdeaListView and PublicIdeaListView and .
IdeaMapr.Views.IdeaListView = Backbone.View.extend
  tagName: 'div',
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, "sync", @render)
    @listenTo(@collection, 'sort', @render)

  set_question_type: (type_int) ->
    @question_type = type_int
        
  render: ->
    self = @
    @$el.empty()

    # The idea list sort causes the highest ranked idea to show at the top.
    @collection.each (idea) ->
      li = new IdeaMapr.Views.IdeaView
        model: idea
      li.set_question_type self.question_type
      
      self.$el.append(li.render().el)
      null

    @
