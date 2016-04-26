IdeaMapr.Views.IdeaListView = Backbone.View.extend
  tagName: 'div',

  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "sync", this.render)
    this.listenTo(this.collection, 'sort', this.render)
    
  render: ->
    self = this
    this.$el.empty()

    # The idea list sort causes the highest ranked idea to show at the top.
    this.collection.each (idea) ->
      li = new IdeaMapr.Views.IdeaView
        model: idea
      self.$el.append(li.render().el)
      null

    this
