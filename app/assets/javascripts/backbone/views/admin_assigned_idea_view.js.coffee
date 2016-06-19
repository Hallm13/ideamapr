IdeaMapr.Views.AdminAssignedIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 idea-box',
  tagName: 'div',
  top_container_selector: '.idea-box'
  
  extend_events: ->
    my_events =
      'keyup .amount-box': (evt) ->
        @model.set('cart_amount', $(evt.target).text())
      'mouseenter .idea-row': (evt) ->
        @add_controls evt, '.idea-box'
      'mouseleave .idea-row': (evt) ->
        @remove_controls evt, '.idea-box'
        
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
