IdeaMapr.Models.PublicViewModel = Backbone.Model.extend
  defaults:
    answered: false
    
  response_data: ->
    rd = @attributes['response_data']
    if @attributes.hasOwnProperty 'id'
      rd['idea_id'] = @get('id')
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
    
