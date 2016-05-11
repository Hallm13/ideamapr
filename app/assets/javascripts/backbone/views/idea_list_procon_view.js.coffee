IdeaMapr.Views.IdeaListProConView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    
  render: ->
    el_html = _.template($('#idealist-procon-template').html())()
    this.$el.html el_html

    view_self = this
    this.collection.each (idea, idx) ->
      li = new IdeaMapr.Views.IdeaView
        model: idea

      li.container = view_self
      li.question_type = view_self.question_type

      view_self.$('#container').append(li.render().el)
    this
