IdeaMapr.Models.DetailComponent = IdeaMapr.Models.PublicViewModel.extend
  defaults:
    # For admin
    text: 'Click to Add'
    ready_for_render: 0
    is_promoted: false
    
    # For admin and also for participant if its a ranking SQ
    ranked: 0

    # for participant
    answered: false
    response_enter_count: 0
    checked: false
  
  initialize: ->
    @original_text = @get('text')

    # At some point, I can swear that I found that initializing objects in default properties caused a
    # weird pointer sharing error.
    @attributes['response_data'] =
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
    
