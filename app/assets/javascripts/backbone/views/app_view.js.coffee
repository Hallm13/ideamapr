IdeaMapr.Views.AppView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')

  render: ->
    this.$el.append(_.template($('#idea-wrapper-template').html()))
    this
    
  append_idea: (view) ->
    this.$el.prepend view.render().el

