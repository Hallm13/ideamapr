IdeaMapr.Models.DetailComponent = Backbone.Model.extend
  defaults:
    text: 'Click to Add'
    is_edited: false
    ready_for_render: 0
    is_promoted: false
    radio_selected: false

  initialize: ->
    @original_text = @get('text')
    @.attributes['response_data'] = 
      answered: false
      checked: false

  set_edited_state: (new_text) ->
    @.set('text', new_text)
        
    if @original_text != new_text
      @.set('is_edited', true)
      @.set('ready_for_render', @.get('ready_for_render') + 1)
    else if @.get('is_edited')
      @.set('is_edited', false)
      @.set('ready_for_render', @.get('ready_for_render') + 1)
    
  response_data: ->
    rd = @.attributes['response_data']
    rd

  set_response_data: (type, data) ->
    @.attributes['response_data']['answered'] = true
    @.attributes['response_data'][type] = data
    if type == 'checked' and data == true
      console.log "set rd checked to " + data + " for idea rank " + @.get('idea_rank')
      @.set('radio_selected', true)
