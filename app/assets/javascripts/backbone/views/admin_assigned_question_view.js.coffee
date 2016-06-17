# It could be possible to rename this parent class into a generic name.
IdeaMapr.Views.AdminAssignedQuestionView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 question-box',
  tagName: 'div',

  extend_events: ->
    my_events = 
      'mouseenter .question-row': (evt) ->
        if $(evt.target).hasClass('question-row')
          container = $(evt.target)
        else
          container = $(evt.target).closest('.question-row')

        container.addClass('showing-controls')
        container.closest('.question-box').find('.controls-box').show({duration: 'medium'})
      
      'mouseleave .question-row': (evt) ->
        if $(evt.target).hasClass('question-row')
          container = $(evt.target)
        else
          container = $(evt.target).closest('.question-row')
        container.removeClass('showing-controls')
        container.closest('.question-box').find('.controls-box').hide()
        
      'click #out': (evt) ->
        @model.set('promoted', -1)
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()
     
  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'extend_events')
    @extend_events()
    @

  render: ->
    template_id = '#survey-question-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html
    div_array = @create_controls()
    @$el.find('.question-row').prepend div_array[0]
    @$el.find('.question-row').append div_array[1]
    
    @
