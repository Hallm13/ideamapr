IdeaMapr.Models.Idea = Backbone.Model.extend
  defaults: ->
    spend_amount: 0
    answered: false
    response_data:
      answered: false
    title: null
    promoted: 0
    ranked: 0
    index: 0
    
  urlRoot: '/ideas',

  initialize: ->
    this.on('move-top', this.grant_top)

  make_example: ->
    @set('title', 'Example Idea')
    @set('description', 'Add ideas like this one by clicking + below.')
    
  increment_note: (type) ->
    if type == 'pro' || type == 'con'
      this.set(type, this.get(type) + 1)

    
  shown_rank: ->
    if this.get('idea_rank') < 0
      return ''
    else
      return this.get('idea_rank')
      
  response_data: ->
    rd = @.attributes['response_data']
    rd['idea_id'] = @get('id')
    rd
      
  set_response_data: (type, data) ->
    @.set('answered', true)
    @.attributes['response_data']['answered'] = true
    @.attributes['response_data'][type] = data

