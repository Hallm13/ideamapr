IdeaMapr.Views.PublicSurveySummaryView = IdeaMapr.Views.SurveyScreenView.extend
  tagName: 'div'

  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, 'change:answered', @render)
    @listenTo(@collection, 'change:view_request', @recrement_question_passthru)
    @
    
  render: ->
    summary_html = _.template($('#survey-summary-template').html())
    @$el.html summary_html
    # HAML::Engine won't let id attribute be html_safe
    @$el.attr 'id', 'summary-screen'
    
    @append_summaries '#skipped-list', false
    @append_summaries '#answered-list', true
    @
    
  append_summaries: (selector, bool) ->
    l = @collection.where(
      answered: bool
    )
    v = new IdeaMapr.Views.SurveyQuestionCollectionView()
    l.survey = @model
    v.model_array = l
    
    @$(selector).append v.render().el
    null

  recrement_question_passthru: (model) ->
    @model.trigger 'survey:recrement_question'
