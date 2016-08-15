IdeaMapr.Views.AdminAssignedIdeaView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  top_container_class: 'component-box'
  initialize: ->
    _.bindAll(@, 'render')
    _.bindAll(@, 'extend_events')
    @extend_events()
    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class
    @run_summary_logic = (new IdeaMapr.Views.SummaryExpander).run_summary_logic

    @

  add_admin_events: ->
    _.extend(@events,
      'click .idea-card-row' : (evt) ->
        uri = document.location.href
        uri = uri.replace(/\?[^\?\/]+$/, '/')
        if uri.match(/\/ideas\/?[^\/]*$/) != null
          # This is not the homepage
          if uri.match(/ideas$/)
            uri += '/'
            
          uri += @model.get('id') + '/edit'
        else
          uri += 'ideas/' + @model.get('id') + '/edit'
        document.location.href = uri
    )
    @delegateEvents()
    @$el.off 'mouseenter', '.idea-row'
    @$el.off 'mouseleave', '.idea-row'
    
  extend_events: ->
    @events =
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

    # Add in admin controls behavior
    _.extend(@events, @base_events)

    # Add in the expander behavior.
    _.extend(@events, (new IdeaMapr.Views.SummaryExpander()).events)
    @delegateEvents()
     
  render: ->
    if $('#type-' + @question_type + '-admin-template').length > 0
      t = _.template($('#type-' + @question_type + '-admin-template').html())
    else
      t = _.template($('#type-' + @question_type + '-public-template').html())

    hash = _.extend({}, @model.attributes,
      shown_component_rank: @model.get('component_rank') + 1,
      card_image_url: @model.get('attachments')['card_image_url']
    )
    
    @$el.html t(hash)
    @add_image_margin()
      
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

    @add_image_margin()
    @run_summary_logic @model
    @
