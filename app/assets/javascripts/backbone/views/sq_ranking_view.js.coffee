IdeaMapr.Views.SQRankingView = IdeaMapr.Views.SurveyQuestionView.extend
  render: (model, options) ->
    # A model for the question view is created when the question is first initialized
    
    template = _.template($('#sq-ranking-template').html())
    this.$el.html(template(this.model.attributes))

    if !this.is_shown
      this.$el.addClass 'myhidden'

    idea_list_view = new IdeaMapr.Views.IdeaListRankingView
      collection: this.collection
      el: this.$('#idea-list')

    idea_list_view.set_question_type(this.model.get('question_type'))
    idea_list_view.render()
    this

