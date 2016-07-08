IdeaMapr.Views.PublicSurveySummaryView = IdeaMapr.Views.SurveyScreenView.extend
  tagName: 'div'

  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, 'survey_question_collection:received_answer', @render)
    @listenTo(@collection, 'survey_question_collection:view_request', @model.recrement_question)
    
    @
    
  render: ->
    summary_html = _.template($('#survey-summary-template').html())()
    @$el.html summary_html
    @append_summaries '#skipped-list', false
    @append_summaries '#answered-list', true
    @
    
  append_summaries: (selector, bool) ->
    l = @collection.where(
      answered: bool
    )
    v = new IdeaMapr.Views.SurveyQuestionCollectionView()
    v.model_array = l
    
    @$(selector).append v.render().el
    null
    
