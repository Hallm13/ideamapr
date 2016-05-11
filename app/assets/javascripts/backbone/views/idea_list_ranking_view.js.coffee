IdeaMapr.Views.IdeaListRankingView = IdeaMapr.Views.IdeaListView.extend
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, 'sort', @render)
    
  render: ->
    el_html = _.template($('#idealist-ranking-template').html())()
    this.$el.html el_html

    if this.collection.ranked_count > 0
      $('#ranked-idea-list .unranked').hide()
      
    view_self = this
    this.collection.each (idea, idx) ->
      li = new IdeaMapr.Views.IdeaView
        model: idea

      li.container = view_self
      li.question_type = view_self.question_type

      if idea.get('idea_rank') > 0
        view_self.$el.find('#ranked-idea-list').append(li.render().el)
      else
        view_self.$el.find('#unranked-idea-list').append(li.render().el)
    this
