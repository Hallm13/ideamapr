IdeaMapr.Views.PublicSurveySummaryView = Backbone.View.extend
  tagName: 'div'
  className: 'row'
  initialize: ->
    _.bindAll(@, 'render')
    @listenTo(@collection, 'survey_question_collection:received_answer', @render)
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
