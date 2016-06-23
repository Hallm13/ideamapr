IdeaMapr.Views.PublicSurveySummaryView = IdeaMapr.Views.SurveyScreenView.extend
  tagName: 'div'

  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, 'survey_question_collection:received_answer', @render)
    @listenTo(@collection, 'survey_question_collection:view_request', @recrement_question)
    
    @
    
  render: ->
    summary_html = _.template($('#survey-summary-template').html())()
    @$el.html summary_html
    
    l = @collection.where(
      answered: false
    )
    v = new IdeaMapr.Views.SurveyQuestionCollectionView()
    v.model_array = l
    
    @$('#skipped-list').append v.render().el

    l = @collection.where(
      answered: true
    )
    v = new IdeaMapr.Views.SurveyQuestionCollectionView()
    v.model_array = l
    
    @$('#answered-list').append v.render().el

    @
    
  recrement_question: (model) ->
    # The summary view's model is set to the containing survey.
    @model.recrement_question {sqn_id: model.get('id')}
