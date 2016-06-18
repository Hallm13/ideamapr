IdeaMapr.Views.AdminAssignedIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 idea-box',
  tagName: 'div',

  extend_events: ->
    my_events =
      'keyup .amount-box': (evt) ->
        @model.set('cart_amount', $(evt.target).text())
    
      'mouseenter .idea-row': (evt) ->
        if $(evt.target).hasClass('idea-row')
          container = $(evt.target)
        else
          container = $(evt.target).closest('.idea-row')

        container.addClass('showing-controls')
        container.closest('.idea-box').find('.controls-box').show({duration: 'medium'})
      
      'mouseleave .idea-row': (evt) ->
        if $(evt.target).hasClass('idea-row')
          container = $(evt.target)
        else
          container = $(evt.target).closest('.idea-row')
        container.removeClass('showing-controls')
        container.closest('.idea-box').find('.controls-box').hide()
        
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
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html

    # Add content editable controls to non idea types
    if @question_type == '5' or @question_type == '6'
      @$el.attr('contentEditable', 'true')
      @$el.attr('onclick', "document.execCommand('selectAll',false,null)")
    if @question_type == '3'
      @$el.find('.amount-box').attr('contentEditable', 'true')
      @$el.find('.amount-box').attr('onclick', "document.execCommand('selectAll',false,null)")
      
    div_array = @create_controls()
    @$el.find('.idea-row').prepend div_array[0]
    @$el.find('.idea-row').append div_array[1]

    
    @
