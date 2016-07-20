IdeaMapr.Views.PublicDetailView = Backbone.View.extend
  className: 'col-xs-12 component-box'
  top_container_selector: '.component-box'
  
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  run_radio_checks: ->
    @model.set_checked()
    @model.set('response_enter_count', @model.get('response_enter_count') + 1)
        
  events:
    'mouseenter .component-row': (evt) ->
      @
    'mouseleave .component-row': (evt) ->
      @
    'change input[type=radio]': (evt) ->
      @run_radio_checks()
      
    'keyup .text-entry-box input[type=text]': (evt) ->
      @model.set_text_entry $(evt.target).val().trim()
      
    'click .radio-choice-text': (evt) ->
      $(evt.target).parent().find('input[type=radio]').prop('checked', true)
      @run_radio_checks()

  unselect: () ->
    @$el.find('input[type=radio]').prop('checked', false)
    @model.set_response_data('checked', false)
    
  render: ->
    t = _.template($('#type-' + @question.get('question_type') + '-public-template').html())
    
    @$el.html(t(@model.attributes))
    @
