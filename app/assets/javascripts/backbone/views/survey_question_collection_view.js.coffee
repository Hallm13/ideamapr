IdeaMapr.Views.SurveyQuestionCollectionView = Backbone.View.extend
  tagName: 'div'
  className: 'col-xs-12'
  initialize: ->
    _.bindAll(@, 'render')
    @

  render: ->
    view_self = @
    @model_array.forEach (m, idx) ->
      v = new IdeaMapr.Views.SurveyQuestionSummaryView(
        model: m
      )
      view_self.$el.append v.render().el
    @

  recrement_question: (v) ->
    # Pass up the event to the survey view, along with the survey question ID that has to be displayed
    @trigger('recrement_question',
      sqn_id: v.model.get('id')
    )
