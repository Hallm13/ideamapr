IdeaMapr.Views.ComponentView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 component-box'
  top_container_selector: '.component-box'
  
  initialize: ->
    _.bindAll(@, 'render')
    @extend_events()
    @
    
  extend_events: ->
    my_events =
      'mouseenter .component-row': (evt) ->
        @add_controls evt, '.component-box'
        @
      'mouseleave .component-row': (evt) ->
        @remove_controls evt, '.component-box'
        @

      'blur .editable-text': (evt) ->
        txt = $(evt.target).text()
        @model.set_edited_state(txt.trim())
        @
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()
      
  render: ->
    t = _.template($('#type-' + @question_type + '-public-template').html())
    
    @$el.html(t(@model.attributes))

    @$el.find('.editable-text').attr('contentEditable', 'true')
    @$el.find('.editable-text').attr('onclick', "document.execCommand('selectAll',false,null)")
    
    if @model.get('is_edited')
      @$el.find('.editable-text').addClass 'edited'
      
    div_array = @create_controls()
    @$el.prepend div_array[0]
    @$el.append div_array[1]

    @
