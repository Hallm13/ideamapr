IdeaMapr.Views.IdeaListView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "sync", this.render)
    
  render: ->
    self = this
    this.collection.each (idea) ->
      li = new IdeaMapr.Views.IdeaView
        model: idea
      self.$el.append(li.render().el)
      null
    this
