IdeaMapr.Models.Idea = IdeaMapr.Models.PublicViewModel.extend
  defaults: ->
    # For admin
    promoted: 0

    # For admin and also for participant if its a ranking SQ
    # Used as a signal that the idea needs to move somewhere ... 1 = up, -1 = down, -10 = outta the list
    ranked: 0
    # For admin and participant, but only admin can write (?)
    cart_amount: 0

    # Does any one need this?
    index: 0

    # For participant
    answered: false
    cart_count: 0
    
  urlRoot: '/ideas',

  initialize: ->
    # Add a summary for the card: first 30 "words"
    unless typeof @attributes['description'] == 'undefined'
      words = @attributes['description'].trim().split(/\s+/)
      if words.length > 30
        @attributes['desc_summary'] = words.slice(0,30).join(' ')
        @has_expansion = true
      else
        @attributes['desc_summary'] = @attributes['description']
        @has_expansion = false
    else
      @attributes['desc_summary'] = ''
      @has_expansion = false
      
    @attributes['response_data'] =
      answered: false
      checked: false

  make_example: (opts) ->
    @set('title', 'Example Idea')
    @set('description', 'Add ideas like this one by clicking + below.')
    @set('component_rank', opts.rank)
  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      @set(type, @get(type) + 1)

  shown_rank: ->
    if @get('component_rank') < 0
      return ''
    else
      return @get('component_rank')
            
  add_feedback: (type, text) ->
    unless text.trim().length == 0
      @set('answered', true)
      @attributes['response_data']['type-0-data']['feedback'][type].push text
      @trigger('idea:new_procon')
      
  toggle_cart_count: ->
    current_count = @get('cart_count')
    if current_count == 0
      @set 'cart_count', 1
    else
      @set 'cart_count', 0
      
    @set_response_data 'cart_count', @get('cart_count')
    
  set_text_entry: (id, txt) ->
    # Used to set title and description for suggested ideas
    # id is either new_idea_title, or new_idea_description
    
    @set_response_data 'text_entry#' + id, txt
