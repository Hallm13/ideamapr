IdeaMapr.Views.SurveyPublicView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')

    @listenTo(@, "semaphore_set", @render)
    @listenTo(@collection, "sync", @set_questions)
    @listenTo(@model, "survey:selection_changed", @change_hidden_class)
    @listenTo(@model, "survey:done", @close_all_screens)
    @listenTo(@model, "survey:server_closed", @thankyou_confirm)
    @listenTo(@model, "survey:server_error", @thankyou_error)
    
    @listenTo(@model, 'survey:has_ideas', @semaphore_increment)
    
    @screens = new Array()
    @semaphore_value = 0
    @

  thankyou_confirm: ->
    @thankyou_screen.find('#messages').text 'You may close this window now.'
  thankyou_error: ->
    @thankyou_screen.find('#messages').text "We couldn't save this response. Please try again. Sorry!"
    
  close_all_screens: ->
    view_self = @
    @screens.forEach (scr, idx) ->
      view_self.screen_remove scr
    @thankyou_screen.show()
        
  semaphore_increment: ->
    @semaphore_value += 1
    if @semaphore_value == 2
      # Now we have both the sq collection and the survey has its list of idea lists...
      view_self = @

      @model.answered = new Array()

      # For now, the intro screen cannot be "answered"
      @model.answered[0] = false
      @collection.each (sq_model, idx) ->
        # ..., each question needs to listen to data changes in its idea list.
        # Each question is unanswered to start with
        view_self.model.answered.push false
        sq_model.survey_token = view_self.model.get('public_link')
        sq_model.assign_idea_list view_self.model.idea_lists[idx]

      # For now, the summary screen cannot be "answered"
      @model.answered.push false
      @trigger('semaphore_set')

  screen_remove: (tgt) ->
    # tgt will be a string for the first and last strings
    if typeof(tgt) == 'string'
      $(tgt).remove()
    else
      tgt.delete_view()
            
  handle_screen_toggle: (tgt) ->
    # tgt will be a string for the first and last strings
    if typeof(tgt) == 'string'
      $(tgt).toggle()
    else
      tgt.toggle_view()
      
  change_hidden_class: ->
    @handle_screen_toggle @screens[@model.get('previous_selection')]
    @handle_screen_toggle @screens[@model.get('current_screen')]
    @

  render: ->
    # Render is triggered after all the survey question screens have been initialized
    # This is only triggered after both sqns and ideas have been fetched, which only happens once.
    
    view_self = this
    @navbar_view = new IdeaMapr.Views.SurveyNavbarView
      collection: @collection
      model: @model
      
    @$('#survey-navbar').append(@navbar_view.render().el)

    b = {title: 'Introduction', screen_body_content: @model.get('introduction'), question_screen_id: 'welcome-screen'}
    intro_html = _.template($('#survey-empty-screen-template').html()) b
    @$('#survey-intro').html intro_html
    
    @screens[0] = '#survey-intro' # The underlying logic is smart and will use the selector when its there to toggle.

    _.each(i for i in [0..@question_count-1], (i) ->
      view_self.screens[i+1].append_idea_template(view_self.model.idea_lists[i])
    )

    summary_view = new IdeaMapr.Views.PublicSurveySummaryView
      model: @model
      collection: @collection
      
    $('#survey-summary').append summary_view.render().el
    summary_view.render()
    @screens.push summary_view

    # Pass a reference to the screens to the survey model, so it can manage toggles.
    @model.screens = @screens

    b = {title: 'Thank you!', screen_body_content: @model.get('thankyou_note'), question_screen_id: 'thankyou-screen'}
    thankyou_html = _.template($('#survey-empty-screen-template').html()) b
    
    @thankyou_screen = @$('#survey-thankyou')
    @thankyou_screen.html thankyou_html
      
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

    # These selectors are used to make the remaining screens in initialize().

    @semaphore_increment('sq')
