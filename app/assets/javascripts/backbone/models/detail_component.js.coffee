IdeaMapr.Models.DetailComponent = IdeaMapr.Models.PublicViewModel.extend
  defaults:
    answered: false
    text: 'Click to Add'
    ready_for_render: 0
    is_promoted: false
  
  initialize: ->
    @original_text = @get('text')

    # At some point, I can swear initializing objects in defaults caused a weird pointer sharing error.
    @.attributes['response_data'] =
      answered: false
      checked: false
      is_edited: false

  set_edited_state: (new_text) ->
    @.set 'text', new_text
        
    if @original_text != new_text
      @is_edited = true
      @.set 'ready_for_render', @.get('ready_for_render') + 1
    else if @.get('is_edited')
      @is_edited = false
      @.set 'ready_for_render', @.get('ready_for_render') + 1
    
  init_type_specific_data: (qn_type) ->
    @
