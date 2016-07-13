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
    @on('move-top', @grant_top)
    @.attributes['response_data'] =
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
    @set('answered', true)
    unless text.trim().length == 0
      @attributes['response_data']['type-0-data']['feedback'][type].push text
      @trigger('idea:new_procon')
      
  toggle_cart_count: ->
    current_count = @get('cart_count')
    if current_count == 0
      @set 'cart_count', 1
    else
      @set 'cart_count', 0
      
    @set_response_data 'cart_count', @get('cart_count')
