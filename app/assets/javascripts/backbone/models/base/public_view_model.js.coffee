IdeaMapr.Models.PublicViewModel = Backbone.Model.extend
  defaults:
    answered: false
    
  response_data: (qn_type) ->
    rd = @attributes['response_data']
    if @attributes.hasOwnProperty 'text'
      # This is a detail, not an idea
      rd['text'] = @get('text')
    else
      # This is an idea, not a detail
      if @attributes.hasOwnProperty 'id'
        rd['idea_id'] = @get('id')
        
      if qn_type == 1
        # Ranking: send back the component_rank
        rd['component_rank'] = @get('component_rank')
      if qn_type == 2
        # New Idea, its title and description are entered by user. Also, its answered attribute
        # is not set via set_response_data
        _.extend(rd, {title: @get('title'), description: @get('description')})
        rd['answered'] = true        
        
    rd

  set_response_data: (type, data) ->
    # We might have more complex logic to decide if an idea has been answered.
    # E.g., removing the pro text counts as un-answering the question, or taking an idea off the shopping cart.

    @set('answered', true)
    @attributes['response_data']['answered'] = true
    @attributes['response_data'][type] = data
    @

  # Is this function needed? Not sure    
  init_type_specific_data: (question_type) ->
    data = @attributes['response_data']
    if question_type == 0
      unless data.hasOwnProperty('type-0-data')
        data['type-0-data'] = new Object()
        
        data['type-0-data']['note_counts'] =
          pro: @get('pro')
          con: @get('con')
        data['type-0-data']['feedback'] =
          pro: []
          con: []
    
