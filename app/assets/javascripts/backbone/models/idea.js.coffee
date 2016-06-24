IdeaMapr.Models.Idea = IdeaMapr.Models.PublicViewModel.extend
  defaults: ->
    # For admin
    promoted: 0
    ranked: 0
    index: 0

    # For participant
    cart_amount: 0
    answered: false
    
  urlRoot: '/ideas',

  initialize: ->
    @on('move-top', @grant_top)
    @.attributes['response_data'] =
      answered: false
      checked: false

  make_example: (opts) ->
    @set('title', 'Example Idea')
    @set('description', 'Add ideas like this one by clicking + below.')
    @set('idea_rank', opts.rank)
  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      @set(type, @get(type) + 1)

    
  shown_rank: ->
    if @get('idea_rank') < 0
      return ''
    else
      return @get('idea_rank')
            
  init_type_specific_data: (qn_type) ->
    data = @attributes['response_data']
    if qn_type == 0
      unless data.hasOwnProperty('type-0-data')
        data['type-0-data'] = new Object
        
        data['type-0-data']['note_counts'] =
          pro: @get('pro')
          con: @get('con')
        data['type-0-data']['feedback'] =
          pro: []
          con: []
    
  add_feedback: (type, text) ->
    @set('answered', true)
    unless text.trim().length == 0
      @attributes['response_data']['type-0-data']['feedback'][type].push text
      @trigger('idea:new_procon')
