IdeaMapr.Views.SurveyQuestionView = Backbone.View.extend
  tagName: 'div',
  className: 'survey-question',
  
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.model, "change", this.render)

  render: ->
    template = _.template($('#sq-template').html())
    this.$el.html(template(this.model.attributes))

    idea_list_view = new IdeaMapr.Views.IdeaListView
      collection: this.model.idea_list,
      el: this.$('#idea-list')
    idea_list_view.render()
    this
