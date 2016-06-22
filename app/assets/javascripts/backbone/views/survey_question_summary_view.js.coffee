IdeaMapr.Views.SurveyQuestionSummaryView = Backbone.View.extend
  tagName: 'div'
  className: 'row survey-qn-summary clickable'
  initialize: ->
    _.bindAll(@, 'render')
    @

  events:
    'click': ->
      @model.set('view_request', @model.get('view_request') + 1)
      
  render: ->
    t = _.template($('#survey-question-summary-template').html())
    @$el.html(t(@model.attributes))
    @
