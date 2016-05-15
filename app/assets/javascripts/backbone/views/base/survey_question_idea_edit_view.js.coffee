IdeaMapr.Views.SurveyQuestionIdeaEditView = Backbone.View.extend
  base_events:
    'click #move-up': (evt) ->
      @model.set('ranked', 1)
    'click #move-down': (evt) ->
      @model.set('ranked', -1)
