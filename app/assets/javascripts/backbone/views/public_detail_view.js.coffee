IdeaMapr.Views.PublicDetailView = IdeaMapr.Views.SurveyQuestionIdeaEditView.extend
  className: 'col-xs-12 component-box'
  top_container_selector: '.component-box'
  
  initialize: ->
    _.bindAll(@, 'render')
    @extend_events()
    @
    
  run_radio_checks: ->
    @model.set_response_data('checked', true)
    @model.set('response_enter_count', @model.get('response_enter_count') + 1)
        
  extend_events: ->
    my_events =
      'mouseenter .component-row': (evt) ->
        @
      'mouseleave .component-row': (evt) ->
        @
      'change input[type=radio]': (evt) ->
        @run_radio_checks()
      'click .editable-text': (evt) ->
        $(evt.target).parent().find('input[type=radio]').prop('checked', true)
        @run_radio_checks()
        
    @events = _.extend({}, @base_events, my_events)
    @delegateEvents()

  unselect: () ->
    @$el.find('input[type=radio]').prop('checked', false)
    @model.set_response_data('checked', false)
    
  render: ->
    t = _.template($('#type-' + @question_type + '-public-template').html())
    
    @$el.html(t(@model.attributes))
    @
