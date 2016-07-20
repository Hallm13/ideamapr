IdeaMapr.Views.SurveyQuestionCollectionView = Backbone.View.extend
  tagName: 'div'
  className: 'col-xs-12'
  initialize: ->
    _.bindAll(@, 'render')
    @

  render: ->
    view_self = @
    
    # model_array = list of questions
    qn_list = @model_array
    @model_array.forEach (m, idx) ->
      v = new IdeaMapr.Views.SurveyQuestionSummaryView(
        model: m
        collection: qn_list
      )
      view_self.$el.append v.render().el
    @
