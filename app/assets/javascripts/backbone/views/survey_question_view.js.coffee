IdeaMapr.Views.SurveyQuestionView = Backbone.View.extend
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  tagName: 'div',
  className: 'myhidden row'

  toggle_view: ->
    if @$el.hasClass 'myhidden'
      @$el.removeClass 'myhidden'
    else
      @$el.addClass 'myhidden'
      
  render: ->
    sq_html =  _.template($('#survey-question-template').html())(@model.attributes)
    @$el.html sq_html
    
    @    
