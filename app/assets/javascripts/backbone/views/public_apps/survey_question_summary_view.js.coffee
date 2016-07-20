IdeaMapr.Views.SurveyQuestionSummaryView = Backbone.View.extend
  tagName: 'div'
  className: 'row survey-qn-summary clickable'
  initialize: ->
    _.bindAll(@, 'render')
    @

  events:
    'click': ->
      @collection.survey.trigger 'survey:recrement_question', {move_to: @model.get('component_rank') + 1}
      
  render: ->
    t = _.template($('#survey-question-summary-template').html())
    @$el.html(t(@model.attributes))
    @
