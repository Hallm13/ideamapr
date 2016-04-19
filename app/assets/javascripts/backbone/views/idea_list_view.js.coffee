IdeaMapr.Views.IdeaListView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "sync", this.render)
    this.listenTo(this.collection, 'sort', this.render)
    
  render: ->
    self = this
    container = $('<div>')
    this.collection.each (idea) ->
      li = new IdeaMapr.Views.IdeaView
        model: idea
      li.set_type self.qn_type
      container.append(li.render().el)
      null

    this.$el.empty()
    this.$el.append container
    this

  set_type: (type_int) ->
    this.qn_type = type_int
