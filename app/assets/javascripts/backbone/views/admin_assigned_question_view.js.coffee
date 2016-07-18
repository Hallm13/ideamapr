IdeaMapr.Views.AdminAssignedQuestionView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  top_container_class: 'question-box'
  className: 'col-xs-12 question-box',
  tagName: 'div',

  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'extend_events')
    
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class
    @extend_events()
    @

  extend_events: ->
    my_events =
      'mouseenter .question-row': (evt) ->
        @add_controls evt, '.question-box'
      'mouseleave .question-row': (evt) ->
        @remove_controls evt, '.question-box'
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()
     
  render: ->
    template_id = '#survey-question-summary-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    div_array = @create_controls()
    @$el.find('.question-row').prepend div_array[0]
    @$el.find('.question-row').append div_array[1]
    
    @
