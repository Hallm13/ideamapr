IdeaMapr.Views.AdminAssignedIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 idea-box',
  tagName: 'div',

  extend_events: ->
    my_events = 
      'mouseenter .idea-row': (evt) ->
        if $(evt.target).hasClass('idea-row')
          container = $(evt.target)
        else
          container = $(evt.target).closest('.idea-row')

        container.addClass('showing-controls')
        container.closest('.idea-box').find('.ranking-control').show({duration: 'medium'})
      
      'mouseleave .idea-row': (evt) ->
        if $(evt.target).hasClass('idea-row')
          container = $(evt.target)
        else
          container = $(evt.target).closest('.idea-row')
        container.removeClass('showing-controls')
        container.closest('.idea-box').find('.ranking-control').hide()
        
      'click #move-out': (evt) ->
        @model.set('promoted', -1)
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()
     
  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'extend_events')
    @extend_events()
    @

  render: ->
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html

    # Add the ranking controls, so that only admins can see this.
    control_div = $('<div>').addClass('ranking-control')
    up_div = $('<div>').attr('id', 'move-up').addClass('control-icon')
    out_div = $('<div>').attr('id', 'move-out').addClass('control-icon')
    down_div = $('<div>').attr('id', 'move-down').addClass('control-icon')
    
    control_div.append(up_div).append(out_div).append(down_div)
    @$el.find('.idea-row').prepend(control_div)
    
    @
