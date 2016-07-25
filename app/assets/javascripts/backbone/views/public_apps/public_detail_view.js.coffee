IdeaMapr.Views.PublicDetailView = Backbone.View.extend
  className: 'col-xs-12 component-box'
  top_container_selector: '.component-box'
  
  initialize: ->
    _.bindAll(@, 'render')
    @
    
  events:
    'change input[type=radio]': (evt) ->
      # Tell the question to figure out which model to set the radio button for.
      @question.change_checked @model.get('id')
        
    'keyup .text-entry-box input[type=text]': (evt) ->
      @model.set_text_entry $(evt.target).val().trim()
      
    'click .radio-choice-text': (evt) ->
      $(evt.target).parent().find('input[type=radio]').click()

  unselect: () ->
    @$el.find('input[type=radio]').prop('checked', false)
    @model.set_response_data('checked', false)
    
  render: ->
    t = _.template($('#type-' + @question.get('question_type') + '-public-template').html())
    
    # Add question id to show in disambiguating radio buttons
    @$el.html t(_.extend({}, @model.attributes, {survey_question_id: @question.get('id')}))
    @
