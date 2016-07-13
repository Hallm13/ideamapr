IdeaMapr.Views.AdminAssignedIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  top_container_class: 'idea-box'
  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'extend_events')
    @extend_events()
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class

    @

  extend_events: ->
    my_events =
      'keydown .amount-box': (evt) ->
        # Arrows, delete, and numbers
        if (evt.keyCode < 48 or evt.keyCode > 57) and (evt.keyCode < 37 or evt.keyCode > 40) and evt.keyCode != 8
          evt.preventDefault()
          evt.stopPropagation()
          
      'keyup .amount-box': (evt) ->
        @model.set('cart_amount', $(evt.target).text())
        
      'mouseenter .idea-row': (evt) ->
        @add_controls evt, '.idea-box'
      'mouseleave .idea-row': (evt) ->
        @remove_controls evt, '.idea-box'
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()
     
  render: ->
    template_id = '#type-' + @question_type + '-public-template'
    html = _.template($(template_id).html())(@model.attributes)
    @$el.html html

    # Add content editable controls to non idea types
    if @question_type == '5' or @question_type == '6'
      @$el.attr('contentEditable', 'true')
      @$el.attr('onclick', "document.execCommand('selectAll',false,null)")
    if @question_type == 3
      @$el.find('.amount-box').attr('contentEditable', 'true')
      @$el.find('.amount-box').attr('onclick', "document.execCommand('selectAll',false,null)")
      
    div_array = @create_controls()
    @$el.find('.idea-row').prepend div_array[0]
    @$el.find('.idea-row').append div_array[1]

    @
