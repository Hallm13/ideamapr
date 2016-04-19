IdeaMapr.Views.AppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')

  render: ->
    this.$el.append($('<div>'))
    this
    
  append_idea: (view) ->
    this.$el.prepend view.render().el

