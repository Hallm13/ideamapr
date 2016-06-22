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
