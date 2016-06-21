IdeaMapr.Models.PublicViewModel = Backbone.Model.extend
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
    
