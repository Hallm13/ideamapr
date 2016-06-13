IdeaMapr.Views.SurveyPublicView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')

    @listenTo(@, "semaphore_set", @render)
    @listenTo(@collection, "sync", @set_questions)
    @listenTo(@model, "survey:selection_changed", @change_hidden_class)
    @listenTo(@model, 'survey:has_ideas', @semaphore_increment, 'survey')
    
    @screens =
      0: '#welcome-screen'
    @semaphore_value = 0
    @

  semaphore_increment: (type) ->
    @semaphore_value += 1
    if @semaphore_value == 2
      @trigger('semaphore_set')
      
  handle_post: (obj) ->
    $.ajax
      type: 'PUT'
      url: '/survey_responses/0'
      contentType: 'application/json'
      data: JSON.stringify(obj)
      success: (d, s, x) ->
        a = 1+2
        window.location.href = '/survey/thank_you'        
        # what is this
      
  events:
    'click #save-response': (evt) ->
      obj =
        responses: @collection.map (elt, idx) ->
          elt.getResponseData()

      sid = $('#survey_id').data('survey-id')
      obj['survey_id'] = sid
      obj['cookie_key'] = $('#cookie_key').val()
      @handle_post(obj)

  handle_toggle: (tgt) ->
    # tgt will be a string for the first and last strings
    if typeof(tgt) == 'string'
      $(tgt).toggle()
    else
      tgt.toggle_view()
      
  change_hidden_class: ->
    @handle_toggle @screens[@model.get('previous_selection')]
    @handle_toggle @screens[@model.get('current_question')]
    @

  render: ->
    # Render is triggered after all the survey question screens have been initialized
    # This is only triggered after both sqns and ideas have been fetched.
    
    view_self = this
    navbar_view = new IdeaMapr.Views.SurveyNavbarView
      collection: @collection
      model: @model
      
    @$('#survey-navbar').append(navbar_view.render().el)

    intro_html = _.template($('#survey-intro-template').html())(@model.attributes)
    @$('#survey-intro').html intro_html
    @screens[0] = '#survey-intro' # The underlying logic is smart and will use the selector when its there to toggle.

    _.each(i for i in [0..@question_count-1], (i) ->
      view_self.screens[i+1].append_idea_template(view_self.model.idea_lists[i])
    )
    thankyou_html = _.template($('#survey-thankyou-template').html())(@model.attributes)
    @$('#survey-thankyou').html thankyou_html
    
    @

  set_questions: ->
    # A question view object is created and appended
    # To the public survey, for each type of question retrieved
    
    view_self = @
    @question_count = 0
    @collection.each (question_object, idx) ->
      sq_view = new IdeaMapr.Views.SurveyQuestionView
        model: question_object

      # the first screen is the intro screen - the rest are questions
      view_self.screens[1 + idx] = sq_view
      view_self.question_count += 1
      view_self.$('#sq-list').append(sq_view.render().el)

    # One screen for each qn + intro + thank you
    @model.set('number_of_screens', 2 + @question_count)
    @screens[1 + @question_count] = '#survey-thankyou' # This selector is used to make the thank you screen in initialize().
    @semaphore_increment('sq')
    
  append_qn_template: (view) ->
    @$el.append view.render().el
