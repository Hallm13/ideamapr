IdeaMapr.Views.SurveyQuestionSummaryView = Backbone.View.extend
  tagName: 'div'
  className: 'row survey-qn-summary'
  initialize: ->
    _.bindAll(@, 'render')
    @

  render: ->
    t = _.template($('#survey-question-summary-template').html())
    @$el.html(t(@model.attributes))
    @
