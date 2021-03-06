IdeaMapr.Models.Survey = Backbone.Model.extend
  initialize: ->
    _.bindAll(@, 'populate_idea_collections')
    @listenTo(@, 'survey:recrement_question', @recrement_question)
    @listenTo(@, 'sync', _.once(@fetch_idea_lists))
    @listenTo(@, 'survey:done', @close_response)

  close_response: ->
    survey_token = @get('public_link')
    url = '/individual_answers/' + survey_token
    model_self = @
    $.ajax
      url: url,
      method: 'PUT',
      statusCode:
        500: ->
          model_self.trigger('survey:server_error')
        404: ->
          model_self.trigger('survey:server_error')
      success: (d, s, x) ->
        model_self.trigger('survey:server_closed')
    
  fetch_idea_lists: ->
    # Participant
    # This is triggered when the sync is done the first time, in order to fetch ideas.
    @idea_list = new IdeaMapr.Models.IdeaListOfLists()
    @idea_list.survey_token = @.get('public_link')
    @idea_list.fetch
      success: @populate_idea_collections

  populate_idea_collections: (model, response, options) ->
    # Participant
    # Survey takes the list of idea lists and stores them in an array to communicate to the individual
    # Survey questions - is this too complicated?

    model_self = @
    @idea_lists = []
    _.each(model.get('list_of_lists'), (component_hash) ->
      if component_hash['type'] == 'idea'
        ic = new IdeaMapr.Collections.IdeaCollection(component_hash['data'])
        ic.survey_token = model_self.get('public_link')
        model_self.idea_lists.push ic
      else
        dc = new IdeaMapr.Collections.DetailsCollection(component_hash['data'])
        dc.survey_token = model_self.get('public_link')
        model_self.idea_lists.push dc
    )

    @trigger('survey:has_ideas')
    @
    
  defaults: ->
    current_screen: 0
    public_link: 'none'
    
  urlRoot: '/surveys/',
  url: ->
    if @admin_mode
      @urlRoot + @get('id')
    else
      @urlRoot + 'public_show/' + @get('public_link')

  trigger_fetches: ->
    if @hasOwnProperty 'questions'
      @questions.fetch()
      
  component_data: ->
    # Return the key information needed to associate questions with a survey
    if @hasOwnProperty('assigned_questions')
      c_data = @assigned_questions.serialize()
    
    {details: c_data}

  component_list: ->
    if @hasOwnProperty('questions')
      @questions
    else
      []
      
  post_response_to_server: ->
    index = @get('current_screen')
    if index != 0 and index != @question_list.length + 1 and @question_list.models[index - 1].get('answered')
      @answered[index] = true
      @question_list.models[index - 1].post_response_to_server()
    
  recrement_question: (options) ->
    @set('previous_selection', @get('current_screen'))
    survey_model_self = @
        
    if options.hasOwnProperty('move_to')
      @set('current_screen', options.move_to)
    else if options.hasOwnProperty('survey_question_id')
      @screens.forEach (screen, idx) ->
      # This could be a string selector instead of a view obj
        if screen.model instanceof IdeaMapr.Models.SurveyQuestion && screen.model.get('id') == options.survey_question_id
          survey_model_self.set('current_screen', idx)
    else
      if options.direction == -1
        @set('current_screen', (@get('current_screen') - 1 + @get('number_of_screens')) % @get('number_of_screens'))
      else if options.direction == 1
        # Click on the final go-right (Finish)
        if @get('current_screen') == @get('number_of_screens') - 1
          @trigger 'survey:done'
        else
          @set('current_screen', (@get('current_screen') + 1) % @get('number_of_screens'))

    # SurveyPublicView and SurveyNavbarView will listen for this event.
    @trigger 'survey:selection_changed'
    
