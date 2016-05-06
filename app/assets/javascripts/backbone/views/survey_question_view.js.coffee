IdeaMapr.Views.SurveyQuestionView = Backbone.View.extend
  tagName: 'div',
  className: 'survey-question screen',

  initialize: ->
    _.bindAll(this, 'render')
    this.model.set('is_shown', false)
    this.listenTo(this.model, "change", this.render)

  toggle_view: ->
    if this.$el.hasClass 'myhidden'
      this.$el.removeClass 'myhidden'
    else
      this.$el.addClass 'myhidden'
            
  render: (model, options) ->
    template = _.template($('#sq-template').html())
    this.$el.html(template(this.model.attributes))

    if !this.is_shown
      this.$el.addClass 'myhidden'

    idea_list_view = new IdeaMapr.Views.IdeaListView
      collection: new IdeaMapr.Collections.IdeaCollection(this.model.attributes.ideas),
      el: this.$('#idea-list')

    idea_list_view.set_question_type(this.model.get('question_type'))
    idea_list_view.render()
    this
