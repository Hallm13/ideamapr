IdeaMapr.Models.Idea = Backbone.Model.extend
  defaults: ->
    cart_amount: 0
    answered: false
    response_data:
      answered: false
    title: null
    promoted: 0
    ranked: 0
    index: 0
    
  urlRoot: '/ideas',

  initialize: ->
    @on('move-top', @grant_top)

  make_example: ->
    @set('title', 'Example Idea')
    @set('description', 'Add ideas like this one by clicking + below.')
    
  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      @set(type, @get(type) + 1)

    
  shown_rank: ->
    if @get('idea_rank') < 0
      return ''
    else
      return @get('idea_rank')
      
  response_data: ->
    rd = @.attributes['response_data']
    rd['idea_id'] = @get('id')
    rd
      
  set_response_data: (type, data) ->
    @.set('answered', true)
    @.attributes['response_data']['answered'] = true
    @.attributes['response_data'][type] = data

