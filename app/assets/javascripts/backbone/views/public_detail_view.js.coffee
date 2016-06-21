IdeaMapr.Views.PublicDetailView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 component-box'
  top_container_selector: '.component-box'
  
  initialize: ->
    _.bindAll(@, 'render')
    @extend_events()
    @
    
  extend_events: ->
    my_events =
      'mouseenter .component-row': (evt) ->
        @
      'mouseleave .component-row': (evt) ->
        @
      'change input[type=radio]': (evt) ->
        @model.set_response_data('checked', true)
      'click .editable-text': (evt) ->
        $(evt.target).parent().find('input[type=radio]').prop('checked', true).change()
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()

  unselect: () ->
    @$el.find('input[type=radio]').prop('checked', false)
    @model.set_response_data('checked', false)
    
  render: ->
    t = _.template($('#type-' + @question_type + '-public-template').html())
    
    @$el.html(t(@model.attributes))
    @
