IdeaMapr.Views.QuestionListView = Backbone.View.extend
  tagName: 'div',

  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.collection, "sync", this.render)
    this.listenTo(this.collection, 'sort', this.render)

  render: ->
    self = this
    this.$el.empty()

    # The idea list sort causes the highest ranked idea to show at the top.
    this.collection.each (qn) ->
      li = new IdeaMapr.Views.QuestionView
        model: qn
      self.$el.append(li.render().el)
      null

    this
