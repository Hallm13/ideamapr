IdeaMapr.Views.DetailView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  top_container_class: 'component-box'
  initialize: ->
    _.bindAll(@, 'render')

    @top_container_selector = '.' + @top_container_class
    @$el.addClass @top_container_class
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
      'click .editable-text': (evt) ->
        $(evt.target).parent().find('input[type=radio]').prop('checked', true)
        @model.set_response_data('checked', true)
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()
      
  render: ->
    t = _.template($('#type-' + @question_type + '-public-template').html())
    
    @$el.html(t(@model.attributes))

    @$el.find('.editable-text').attr('contentEditable', 'true')
    @$el.find('.editable-text').attr('onclick', "document.execCommand('selectAll',false,null)")
    
    if @model.is_edited
      @$el.find('.editable-text').addClass 'edited'
      
    div_array = @create_controls()
    @$el.prepend div_array[0]
    @$el.append div_array[1]

    @
