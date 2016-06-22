IdeaMapr.Views.SurveyScreenView = Backbone.View.extend
  toggle_view: ->
    if @$el.hasClass 'myhidden'
      @$el.removeClass 'myhidden'
    else
      @$el.addClass 'myhidden'
