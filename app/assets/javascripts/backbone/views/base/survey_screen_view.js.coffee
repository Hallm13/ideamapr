IdeaMapr.Views.SurveyScreenView = Backbone.View.extend
  className: 'myhidden row'
  
  toggle_view: ->
    if @$el.hasClass 'myhidden'
      @$el.removeClass 'myhidden'
    else
      @$el.addClass 'myhidden'

  delete_view: ->
    @$el.detach()
    @
