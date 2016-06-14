IdeaMapr.Models.DetailComponent = Backbone.Model.extend
  defaults:
    text: 'Click to Add'
    is_edited: false
    ready_for_render: 0
    is_promoted: false

  initialize: ->
    @original_text = @get('text')

  set_edited_state: (new_text) ->
    @.set('text', new_text)
        
    if @original_text != new_text
      @.set('is_edited', true)
      @.set('ready_for_render', @.get('ready_for_render') + 1)
    else if @.get('is_edited')
      @.set('is_edited', false)
      @.set('ready_for_render', @.get('ready_for_render') + 1)
    
  response_data: ->
    _.keys(@.attributes['response_data'])
  set_response_data: (type, data) ->
    @.attributes['response_data'][type] = data
