IdeaMapr.Models.SurveyQuestion = Backbone.Model.extend
  defaults: ->
    view_request: 0
    answered: false
    
    # For admin
    ranked: 0
    
  urlRoot: '/survey_question'

  change_checked: (id) ->
    # set everything except model with ID id, to false.
    @idea_list.models.forEach (elt, idx) ->
      if elt.get('id') == id
        elt.set_response_data 'checked', true
      else
        elt.set_response_data 'checked', false
        
  set_field_details: ->
    unless @field_details
      @field_details = new IdeaMapr.Collections.DetailsCollection()
      @field_details.survey_question_id = @get('id')
    @field_details

  assign_idea_list: (idea_or_details_coll) ->
    # Participant
    @idea_list = idea_or_details_coll
    @listenTo(idea_or_details_coll, 'answered', (coll) ->
      @set('answered', coll.answered)
    )
    idea_or_details_coll.survey_question_id = @get('id')
    idea_or_details_coll.question_type = @get('question_type')
    idea_or_details_coll
    
  set_idea_list: ->
    # Admin ... probably should abstract this and assign_idea_list together at some point. TODO
    unless @idea_list
      @idea_list = new IdeaMapr.Collections.IdeaCollection()
      @idea_list.survey_question_id = @get('id')
      @idea_list.question_type = @get('question_type')
    @idea_list

  trigger_fetches: ->
    if @hasOwnProperty 'idea_list'
      @idea_list.fetch()
    if @hasOwnProperty 'field_details'
      @field_details.fetch()
      
  component_list: ->
    if @hasOwnProperty('idea_list')
      @idea_list
    else
      []
      
  component_data: ->
    # Return the key information needed to associate either details or ideas with a SQ

    if @hasOwnProperty('field_details') and (@get('question_type') == 5 or @get('question_type') == 6)
      @field_details.question_type = @get('question_type')
      c_data = @field_details.serialize()
    else
      # the underlying idea management view would have added this property
      @assigned_ideas.question_type = @get('question_type')
      c_data = @assigned_ideas.serialize()
    
    {question_type: @get('question_type'), details: c_data}

  post_response_to_server: ->
    # Don't bother doing anything if the survey wasn't answered.
    return if @get('answered') == false
    url = '/individual_answers'

    d={}

    # This token was set in survey_public_view:#semaphore_increment.
    d['survey_token'] = @survey_token
    d['survey_question_id'] = @get('id')
    d['response_data'] = JSON.stringify({data: @response_data()})
    $.post url, d, (d, s, x) ->
      
  response_data: ->
    # Collect all the responses from the individual answers

    # This should have been set in assign_idea_list() above.
    question_type = @get('question_type')
    @idea_list.map (idea_or_detail) ->
      idea_or_detail.response_data question_type
