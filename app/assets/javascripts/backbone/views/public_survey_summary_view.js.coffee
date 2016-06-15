IdeaMapr.Views.PublicSurveySummaryView = Backbone.View.extend
  tagName: 'div'
  className: 'row'
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@.collection, 'survey_question_collection:received_answer', @render)

  render: ->
    d = {question_count: @collection.models.length}
    d['answered_qns_count'] = _.select(@collection.models, (m) ->
      m.get('answered')
    ).length
      
    summary_html = _.template($('#survey-summary-template').html())(d)
    @$el.html summary_html
